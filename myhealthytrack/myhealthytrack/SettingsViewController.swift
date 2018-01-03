//
//  SettingsViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/21/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit
import JTAppleCalendar

class SettingsViewController: UIViewController, SettingsSleepProtocol, SettingsActivityProtocol, SettingsWaterProtocol, SettingsFruitProtocol, SettingsVegetableProtocol {
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var fruitLabel: UILabel!
    @IBOutlet weak var vegetableLabel: UILabel!
    
    @IBOutlet weak var sleepHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sleepDisclosureView: UIView!
    @IBOutlet weak var sleepMainView: UIView!
    @IBOutlet weak var sleepRecommendedLabel: UILabel!
    
    @IBOutlet weak var fruitHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fruitDisclosureView: UIView!
    @IBOutlet weak var fruitMainView: UIView!
    @IBOutlet weak var fruitRecommendedLabel: UILabel!
    
    @IBOutlet weak var vegetableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vegetableDisclosureView: UIView!
    @IBOutlet weak var vegetableMainView: UIView!
    @IBOutlet weak var vegetableRecommendedLabel: UILabel!
    
    @IBOutlet weak var waterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var waterDisclosureView: UIView!
    @IBOutlet weak var waterMainView: UIView!
    @IBOutlet weak var waterRecommendedLabel: UILabel!
    
    @IBOutlet weak var activityHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityDisclosureView: UIView!
    @IBOutlet weak var activityMainView: UIView!
    @IBOutlet weak var activityRecommendedLabel: UILabel!
    
    @IBOutlet weak var generalLabel: UILabel!
    @IBOutlet weak var dailyGoalsLabel: UILabel!
    
    
    let settings = SettingsManager.sharedInstance
    
    var currDay : DaysOfWeek?
    var currExpandedView : UIView?
    var currExpandedConstraint : NSLayoutConstraint?
    
    enum settingsDataType{
        case sleep
        case activity
        case water
        case fruits
        case vegetables
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the labels to show the current target numbers
        vegetableLabel.text = "\(NSLocalizedString("Your daily goal is", comment: " ")) \(settings.getTargetVegetables()) \(NSLocalizedString("vegetables", comment: " "))"
        fruitLabel.text = "\(NSLocalizedString("Your daily goal is", comment: " ")) \(settings.getTargetFruit()) \(NSLocalizedString("fruit", comment: " "))"
        activityLabel.text = "\(NSLocalizedString("Your daily goal is", comment: " ")) \(settings.getTargetSteps()) \(NSLocalizedString("steps", comment: " "))"
        sleepLabel.text = "\(NSLocalizedString("Your daily goal is", comment: " ")) \(settings.getTargetSleep()) \(NSLocalizedString("hours", comment: " "))"
        waterLabel.text = "\(NSLocalizedString("Your daily goal is", comment: " ")) \(settings.getTargetWater()) \(NSLocalizedString("glasses", comment: " "))"

        colorizeView()
    }
    
    func colorizeView() {
        // Color view according to color theme
        mainView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().mediumColor
        
        generalLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        dailyGoalsLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor

        sleepDisclosureView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        activityDisclosureView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        waterDisclosureView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        fruitDisclosureView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        vegetableDisclosureView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        
        sleepMainView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        activityMainView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        waterMainView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        fruitMainView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        vegetableMainView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        
        sleepLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        sleepRecommendedLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        
        activityLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        activityRecommendedLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        
        waterLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        waterRecommendedLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        
        fruitLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        fruitRecommendedLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        
        vegetableLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        vegetableRecommendedLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set the delegate before you open a new view controller
        switch segue.identifier! {
        case "settingsSleep":
            let destinationVC = segue.destination as! SettingsSleepViewController
            destinationVC.mDelegate = self
        case "settingsActivity":
            let destinationVC = segue.destination as! SettingsActivityViewController
            destinationVC.mDelegate = self
        case "settingsWater":
            let destinationVC = segue.destination as! SettingsWaterViewController
            destinationVC.mDelegate = self
        case "settingsFruit":
            let destinationVC = segue.destination as! SettingsFruitViewController
            destinationVC.mDelegate = self
        case "settingsVegetables":
            let destinationVC = segue.destination as! SettingsVegetableViewController
            destinationVC.mDelegate = self
        default:
            break
        }
    }
    
    @IBAction func editSleep(_ sender: Any) {
        // open sleep edit view
        performSegue(withIdentifier: "settingsSleep", sender: self)
    }
    
    @IBAction func editActivity(_ sender: Any) {
        // open activity edit view
        performSegue(withIdentifier: "settingsActivity", sender: self)
    }
    
    @IBAction func editWater(_ sender: Any) {
        // open water edit view
        performSegue(withIdentifier: "settingsWater", sender: self)
    }
    
    @IBAction func editFruit(_ sender: Any) {
        // open fruit edit view
        performSegue(withIdentifier: "settingsFruit", sender: self)
    }
    
    @IBAction func editVegetables(_ sender: Any) {
        // open vegetable edit view
        performSegue(withIdentifier: "settingsVegetables", sender: self)
    }
    
    @IBAction func toggleSleepDisclosure(_ sender: Any) {
        if sleepDisclosureView.alpha > 0.5 {
            // the sleep view was opened so close it and return
            animateDisclosureHide(constraint: sleepHeightConstraint, disclosureView: sleepDisclosureView)
            return
        } else if let oldView = currExpandedView {
            // a different view was open so close that one
            animateDisclosureHide(constraint: currExpandedConstraint!, disclosureView: oldView)
        }
        // expand the sleep view
        animateDisclosureReveal(constraint: sleepHeightConstraint, disclosureView: sleepDisclosureView)
    }
    
    @IBAction func toggleActivityDisclosure(_ sender: Any) {
        if activityDisclosureView.alpha > 0.5 {
            // the activity view was opened so close it and return
            animateDisclosureHide(constraint: activityHeightConstraint, disclosureView: activityDisclosureView)
            return
        } else if let oldView = currExpandedView {
            // a different view was open so close that one
            animateDisclosureHide(constraint: currExpandedConstraint!, disclosureView: oldView)
        }
        // expand the activity view
        animateDisclosureReveal(constraint: activityHeightConstraint, disclosureView: activityDisclosureView)
    }
    
    @IBAction func toggleWaterDisclosure(_ sender: Any) {
        if waterDisclosureView.alpha > 0.5 {
            // the water view was opened so close it and return
            animateDisclosureHide(constraint: waterHeightConstraint, disclosureView: waterDisclosureView)
            return
        } else if let oldView = currExpandedView {
            // a different view was open so close that one
            animateDisclosureHide(constraint: currExpandedConstraint!, disclosureView: oldView)
        }
        // expand the water view
        animateDisclosureReveal(constraint: waterHeightConstraint, disclosureView: waterDisclosureView)
    }
    
    @IBAction func toggleFruitDisclosure(_ sender: Any) {
        if fruitDisclosureView.alpha > 0.5 {
            // the fruit view was opened so close it and return
            animateDisclosureHide(constraint: fruitHeightConstraint, disclosureView: fruitDisclosureView)
            return
        } else if let oldView = currExpandedView {
            // a different view was open, so close that one
            animateDisclosureHide(constraint: currExpandedConstraint!, disclosureView: oldView)
        }
        // expand the fruit view
        animateDisclosureReveal(constraint: fruitHeightConstraint, disclosureView: fruitDisclosureView)
    }
    
    @IBAction func targetVegetableDisclosure(_ sender: Any) {
        if vegetableDisclosureView.alpha > 0.5 {
            // The vegetable view was opened so close it and return
            animateDisclosureHide(constraint: vegetableHeightConstraint, disclosureView: vegetableDisclosureView)
            return
        } else if let oldView = currExpandedView {
            // A differnt view was open, so close that one
            animateDisclosureHide(constraint: currExpandedConstraint!, disclosureView: oldView)
        }
        // expand the vegetable view
        animateDisclosureReveal(constraint: vegetableHeightConstraint, disclosureView: vegetableDisclosureView)
    }
    
    func animateDisclosureHide(constraint: NSLayoutConstraint, disclosureView: UIView) {
        // collapse the view to hide the goal information-
        constraint.constant = 40
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: [.curveEaseIn], animations: { () -> Void in
            disclosureView.alpha = 0.0
            self.view.layoutIfNeeded()
            if self.currExpandedConstraint == constraint {
                self.currExpandedConstraint = nil
            }
            if self.currExpandedView == disclosureView {
                self.currExpandedView = nil
            }
        }, completion: nil)
    }
    
    func animateDisclosureReveal(constraint: NSLayoutConstraint, disclosureView: UIView) {
        // Expand the view to reveal the goal information
        constraint.constant = 110
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: [.curveEaseOut], animations: { () -> Void in
            disclosureView.alpha = 1.0
            self.view.layoutIfNeeded()
            self.currExpandedConstraint = constraint
            self.currExpandedView = disclosureView
        }, completion: nil)
    }
    
    func updateVegetables(vegetables: Int?) {
        if vegetables != nil {
            // set the value of vegetables in settings and update text
            settings.setTargetVegetables(newTarget: vegetables!)
            vegetableLabel.text = "\(NSLocalizedString("Your daily goal is", comment: " ")) \(vegetables!) \(NSLocalizedString("vegetables", comment: " "))"
        }
    }
    
    func updateFruit(fruit: Int?) {
        if fruit != nil {
            // set the value of fruit in settings and update text
            settings.setTargetFruit(newTarget: fruit!)
            fruitLabel.text = "\(NSLocalizedString("Your daily goal is", comment: " ")) \(fruit!) \(NSLocalizedString("fruit", comment: " "))"

        }
    }
    
    func updateActivity(activity: Int?) {
        if activity != nil {
            // set the value of activity in settings and update text
            settings.setTargetSteps(newTarget: activity!)
            activityLabel.text = "\(NSLocalizedString("Your daily goal is", comment: " ")) \(activity!) \(NSLocalizedString("steps", comment: " "))"

        }
    }
    
    func updateSleep(sleep: Double?) {
        if sleep != nil {
            // set the value of sleep in settings and update text
            settings.setTargetSleep(newTarget: sleep!)
            sleepLabel.text = "\(NSLocalizedString("Your daily goal is", comment: " ")) \(sleep!) \(NSLocalizedString("hours", comment: " "))"

        }
    }
    
    func updateWater(water: Int?) {
        if water != nil {
            // set the value of water in settings and update text
            settings.setTargetWater(newTarget: water!)
            waterLabel.text = "\(NSLocalizedString("Your daily goal is", comment: " ")) \(water!) \(NSLocalizedString("glasses", comment: " "))"

        }
    }
}
