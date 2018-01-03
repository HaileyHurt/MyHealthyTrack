//
//  DayViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/1/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit
import Charts
import CoreData

class DayViewController: UIViewController, MoodProtocol, SleepProtocol, ActivityProtocol, WaterProtocol, FruitProtocol, VegetableProtocol {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var dailyGoalLabel: UILabel!
    @IBOutlet weak var bottomLegendView: UIView!
    @IBOutlet weak var topLegendView: UIView!
    @IBOutlet weak var zeroPercentLabel: UILabel!
    @IBOutlet weak var hundredPercentLabel: UILabel!
    
    @IBOutlet weak var moodView: UIView!
    @IBOutlet weak var sleepView: UIView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var waterView: UIView!
    @IBOutlet weak var fruitView: UIView!
    @IBOutlet weak var vegetableView: UIView!
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var moodStack: UIStackView!
    @IBOutlet weak var waterStack: UIStackView!
    @IBOutlet weak var fruitStack: UIStackView!
    @IBOutlet weak var vegetableStack: UIStackView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpHeader: UILabel!
    @IBOutlet weak var popUpDescription: UILabel!
    @IBOutlet weak var popUpTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sunButton: UIButton!
    @IBOutlet weak var monButton: UIButton!
    @IBOutlet weak var tueButton: UIButton!
    @IBOutlet weak var wedButton: UIButton!
    @IBOutlet weak var thuButton: UIButton!
    @IBOutlet weak var friButton: UIButton!
    @IBOutlet weak var satButton: UIButton!
    let settings = SettingsManager.sharedInstance
    
    var day: Day?
    var week: [Date?]!
    var currSelectedIndex: Int!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set up the chart view
        var rightYAxis : YAxis = chartView.leftAxis
        var leftYAxis : YAxis = chartView.rightAxis
        
        chartView.borderColor = UIColor.clear
        chartView.borderLineWidth = 0.0
        chartView.chartDescription = nil
        chartView.chartDescription?.text = ""
        chartView.drawBordersEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawMarkers = false
        rightYAxis.drawAxisLineEnabled = false
        rightYAxis.drawGridLinesEnabled = false
        rightYAxis.drawLabelsEnabled = false
        leftYAxis.drawAxisLineEnabled = false
        leftYAxis.drawGridLinesEnabled = false
        leftYAxis.drawLabelsEnabled = false
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.legend.enabled = false
        
        dailyGoalLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)

        colorizeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update values for current day
        setChart()
        refreshDayValues()
        populateWeek()
        updateTitle()
    }
    
    func colorizeView() {
        // color view according to color theme
        mainView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().mediumColor
        
        sunButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        sunButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
        monButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        monButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
        tueButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        tueButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
        wedButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        wedButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
        thuButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        thuButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
        friButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        friButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
        satButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        satButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
        
        chartView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        bottomLegendView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        topLegendView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        dailyGoalLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        hundredPercentLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        zeroPercentLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        
        moodView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        sleepView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        activityView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        waterView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        fruitView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        vegetableView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor

        if let oldIndex = currSelectedIndex {
            // find the selected day of week and color it as selected
            switch oldIndex {
            case 0:
                sunButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
                
                sunButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
            case 1:
                monButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
                monButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
            case 2:
                tueButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
                tueButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
            case 3:
                wedButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
                wedButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
            case 4:
                thuButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
                thuButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
            case 5:
                friButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
                friButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
            default:
                satButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
                satButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
            }
        }
    }
    
    func switchToDate(newDate : Date) {
        if let oldIndex = currSelectedIndex {
            // unselect the previously selected day
            switch oldIndex {
            case 0:
                sunButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor

                sunButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
            case 1:
                monButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor
                monButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
            case 2:
                tueButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor
                tueButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
            case 3:
                wedButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor
                wedButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
            case 4:
                thuButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor
                thuButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
            case 5:
                friButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor
                friButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
            default:
                satButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().darkColor
                satButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: .normal)
            }
        }
        
        // get the day and select it
        let newDate = Calendar.current.startOfDay(for: newDate)
        day = DayManager.sharedInstance.getDayForDate(date: newDate)
        currSelectedIndex = Calendar.current.component(.weekday, from: day!.date! as Date) - 1
        
        // update the view for the new date
        setChart()
        refreshDayValues()
        populateWeek()
        updateTitle()
    }
    
    func updateTitle () {
        // get the day value for the date
        let dateComponents = Calendar.current.component(.day, from: day!.date! as Date)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        let dayVal : String = numberFormatter.string(from: dateComponents as NSNumber)!
        
        // get the month value for the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
        // set the navigation item to print out the date
        let dateString = "\(dateFormatter.string(from: day!.date! as Date)) \(dayVal), \(String(Calendar.current.component(.year, from: day!.date! as Date)))"
        navigationItem.title = dateString
    }
    
    func populateWeek() {
        // if sunday is nil make button disappear, otherwise set its title to the date
        if week[0] == nil {
            sunButton.alpha = 0.0
            sunButton.isUserInteractionEnabled = false
        } else {
            sunButton.setTitle("\(Calendar.current.component(.day, from: week[0]!))", for: UIControlState.normal)
        }
        
        // if monday is nil make button disappear, otherwise set its title to the date
        if week[1] == nil {
            monButton.alpha = 0.0
            monButton.isUserInteractionEnabled = false
        } else {
            monButton.setTitle("\(Calendar.current.component(.day, from: week[1]!))", for: UIControlState.normal)
        }
        
        // if tuesday is nil make button disappear, otherwise set its title to the date
        if week[2] == nil {
            tueButton.alpha = 0.0
            tueButton.isUserInteractionEnabled = false
        } else {
            tueButton.setTitle("\(Calendar.current.component(.day, from: week[2]!))", for: UIControlState.normal)
        }
        
        // if wednesday is nil make button disappear, otherwise set its title to the date
        if week[3] == nil {
            wedButton.alpha = 0.0
            wedButton.isUserInteractionEnabled = false
        } else {
            wedButton.setTitle("\(Calendar.current.component(.day, from: week[3]!))", for: UIControlState.normal)
        }
        
        // if thursday is nil make button disappear, otherwise set its title to the date
        if week[4] == nil {
            thuButton.alpha = 0.0
            thuButton.isUserInteractionEnabled = false
        } else {
            thuButton.setTitle("\(Calendar.current.component(.day, from: week[4]!))", for: UIControlState.normal)
        }
        
        // if friday is nil make button disappear, otherwise set its title to the date
        if week[5] == nil {
            friButton.alpha = 0.0
            friButton.isUserInteractionEnabled = false
        } else {
            friButton.setTitle("\(Calendar.current.component(.day, from: week[5]!))", for: UIControlState.normal)
        }
        
        // if saturday is nil make button disappear, otherwise set its title to the date
        if week[6] == nil {
            satButton.alpha = 0.0
            satButton.isUserInteractionEnabled = false
        } else {
            satButton.setTitle("\(Calendar.current.component(.day, from: week[6]!))", for: UIControlState.normal)
        }
        
        // select the current day by coloring it differently
        switch currSelectedIndex {
        case 0:
            sunButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
            sunButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
        case 1:
            monButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
            monButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
        case 2:
            tueButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
            tueButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
        case 3:
            wedButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
            wedButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
        case 4:
            thuButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
            thuButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
        case 5:
            friButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
            friButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
        default:
            satButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
            satButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().darkColor, for: .normal)
        }
    }
    
    func setChart(){
        // clear old data
        chartView.clearValues()
        
        // Add a data point for each of the fields
        // The value will either be loaded from the Day or set to a default of 0
        let dataPoints: [String] = ["", "", "", "", "", ""]
        var values: [Double] = [Double]()
        values.append((day?.mood)! > 0 ? (day?.mood)! : 0)
        values.append(Double((day?.sleep)!)/Double(settings.getTargetSleep()) >= 0 ? Double((day?.sleep)!)/Double(settings.getTargetSleep()) : 0)
        values.append(Double((day?.steps)!)/Double(settings.getTargetSteps()))
        values.append(Double((day?.water)!)/Double(settings.getTargetWater()) >= 0 ? Double((day?.water)!)/Double(settings.getTargetWater()) : 0)
        values.append(Double((day?.fruit)!)/Double(settings.getTargetFruit()) >= 0 ? Double((day?.fruit)!)/Double(settings.getTargetFruit()) : 0)
        values.append(Double((day?.vegetables)!)/Double(settings.getTargetVegetables()) >= 0 ? Double((day?.vegetables)!)/Double(settings.getTargetVegetables()) : 0)
        
        // Add the values into the bar chart
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        // Set the data and colors of the chart
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        chartDataSet.drawValuesEnabled = false
        chartDataSet.colors = [UIColor.init(hex: "CC56BE"), UIColor.lightGray, UIColor.init(hex: "EB6158"), UIColor.init(hex: "00A4B2"), UIColor.init(hex: "FF9A52"), UIColor.init(hex: "52E87E")]
        
        // Axis and visibility configurations for the chart
        let chartData = BarChartData(dataSets: [chartDataSet])
        chartView.autoScaleMinMaxEnabled = false
        let rightYAxis : YAxis = chartView.leftAxis
        rightYAxis.axisMinimum = 0.0;
        rightYAxis.axisMaximum = 1.0;
        chartView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        chartView.data = chartData
        
        // update and draw chart
        chartData.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    func refreshDayValues(){
        if (day!.mood > 0.0) {
            // update the mood with the daily value
            var imageView : UIImageView
            switch Mood(rawValue: day!.mood)! {
            case .VeryHappy:
                imageView = VeryHappyFaceImage()
            case .Happy:
                imageView = HappyFaceImage()
            case .OK:
                imageView = MediumFaceImage()
            case .Sad:
                imageView = SadFaceImage()
            case .VerySad:
                imageView = VerySadFaceImage()
            default:
                imageView = MediumFaceImage()
            }
            updateMood(mood: Mood(rawValue: (day?.mood)!)!, imageView: imageView)
        } else {
            // no mood value has been set, keep empty
            while moodStack.arrangedSubviews.count > 0 {
                let deletedView = moodStack.arrangedSubviews[0]
                moodStack.removeArrangedSubview(deletedView)
                deletedView.removeFromSuperview()
            }
        }
        
        if (day!.sleep >= 0.0) {
            // update the sleep with the daily value
            updateSleep(sleep: day?.sleep, animated: false)
        } else {
            // no sleep value has been set, keep empty
            sleepLabel.text = ""
        }
        
        if ( day!.steps >= 0){
            // update the steps with the daily value
            updateActivity(activity: Int(truncatingBitPattern: (day?.steps)!), animated: false)
        } else {
            // no activity value has been set, keep empty
            activityLabel.text = ""
        }
        
        if (day!.water >= 0) {
            // update the water with the daily value
            updateWater(water: Int(truncatingBitPattern: (day?.water)!), animated: false)
        } else {
            // no water value has been set, empty stack view
            if waterStack.arrangedSubviews.count > 0 {
                repeat{
                    let deletedView = waterStack.arrangedSubviews[0]
                    waterStack.removeArrangedSubview(deletedView)
                    deletedView.removeFromSuperview()
                } while waterStack.arrangedSubviews.count > 0
            }
        }
        
        if (day!.fruit >= 0) {
            // update the fruit with the daily value
            updateFruit(fruit: Int(truncatingBitPattern: (day?.fruit)!), animated: false)
        } else {
            // no fruit value has been set, empty stack view
            if fruitStack.arrangedSubviews.count > 0 {
                repeat{
                    let deletedView = fruitStack.arrangedSubviews[0]
                    fruitStack.removeArrangedSubview(deletedView)
                    deletedView.removeFromSuperview()
                } while fruitStack.arrangedSubviews.count > 0
            }
        }
        
        if (day!.vegetables >= 0) {
            // update the vegetables with the daily value
            updateVegetables(vegetables: Int(truncatingBitPattern: (day?.vegetables)!), animated: false)
        } else {
            // no vegetable value has been set, empty stack view
            if vegetableStack.arrangedSubviews.count > 0 {
                repeat{
                    let deletedView = vegetableStack.arrangedSubviews[0]
                    vegetableStack.removeArrangedSubview(deletedView)
                    deletedView.removeFromSuperview()
                } while vegetableStack.arrangedSubviews.count > 0
            }
        }
    }
    
    func updateMood(mood: Mood, imageView: UIImageView) {
        if mood != Mood.NoData {
            // update the day in persistent storage
            day?.mood = mood.rawValue
            DayManager.sharedInstance.updateDay(day: day)
            setChart()
            
            // update the mood image
            while moodStack.arrangedSubviews.count > 0 {
                let deletedView = moodStack.arrangedSubviews[0]
                moodStack.removeArrangedSubview(deletedView)
                deletedView.removeFromSuperview()
            }
            
            moodStack.addArrangedSubview(imageView)
            
        }
    }
    
    func updateVegetables(vegetables: Int?, animated: Bool) {
        if vegetables != nil {
            day?.vegetables = Int64(vegetables!)
            if animated {
                // make the popup appear with appropriate message
                if vegetables! < settings.getTargetVegetables() {
                    animatePopUp(headingText: "\(NSLocalizedString("Keep Going!", comment: " "))", descriptionText: "\(NSLocalizedString("You are only", comment: " ")) \(settings.getTargetVegetables() - vegetables!) \(NSLocalizedString("vegetable servings away from your daily goal!", comment: " "))")
                } else if vegetables! == settings.getTargetVegetables() {
                    animatePopUp(headingText: "\(NSLocalizedString("Congratulations!", comment: " "))", descriptionText: "\(NSLocalizedString("You have reached your daily goal of", comment: " ")) \(settings.getTargetVegetables()) \(NSLocalizedString("vegetable servings!", comment: " "))")
                } else {
                    animatePopUp(headingText: "\(NSLocalizedString("Congratulations!", comment: " "))", descriptionText: "\(NSLocalizedString("You have eaten", comment: " ")) \(vegetables!  - settings.getTargetVegetables()) \(NSLocalizedString("vegetable servings more than your goal!", comment: " "))")
                }
            }
            // update the day in persistent storage
            DayManager.sharedInstance.updateDay(day: day)
            setChart()
            
            if vegetableStack.arrangedSubviews.count < vegetables! {
                // add the neccessary amount of vegetable images from the stack view
                repeat {
                    vegetableStack.addArrangedSubview(VegetableImage())
                } while vegetableStack.arrangedSubviews.count < vegetables!
            } else if vegetableStack.arrangedSubviews.count > vegetables! {
                // remove the neccessary amount of vegetable images from the stack view
                repeat{
                    let deletedView = vegetableStack.arrangedSubviews[0]
                    vegetableStack.removeArrangedSubview(deletedView)
                    deletedView.removeFromSuperview()
                } while vegetableStack.arrangedSubviews.count > vegetables!
            }
        }
    }
    
    func updateFruit(fruit: Int?, animated: Bool) {
        if fruit != nil {
            day?.fruit = Int64(fruit!)
            if animated {
                // make the popup appear with appropriate message
                if fruit! < settings.getTargetFruit() {
                    animatePopUp(headingText: "\(NSLocalizedString("Keep Going!", comment: " "))", descriptionText: "\(NSLocalizedString("You are only", comment: " ")) \(settings.getTargetFruit() - fruit!) \(NSLocalizedString("fruit servings away from your daily goal!", comment: " "))")
                } else if fruit! == settings.getTargetFruit() {
                    animatePopUp(headingText: "\(NSLocalizedString("Congratulations!", comment: " "))", descriptionText: "\(NSLocalizedString("You have reached your daily goal of", comment: " ")) \(settings.getTargetFruit()) \(NSLocalizedString("fruit servings!", comment: " "))")
                } else {
                    animatePopUp(headingText: "\(NSLocalizedString("Congratulations!", comment: " "))", descriptionText: "\(NSLocalizedString("You have eaten", comment: " ")) \(fruit!  - settings.getTargetFruit()) \(NSLocalizedString("fruit servings more than your goal!", comment: " "))")
                }
            }
            // update the day in persistent storage
            DayManager.sharedInstance.updateDay(day: day)
            setChart()
            
            if fruitStack.arrangedSubviews.count < fruit! {
                // add the neccessary amount of fruit images from the stack view
                repeat {
                    fruitStack.addArrangedSubview(FruitImage())
                } while fruitStack.arrangedSubviews.count < fruit!
            } else if fruitStack.arrangedSubviews.count > fruit! {
                // remove the neccessary amount of fruit images from the stack view
                repeat{
                    let deletedView = fruitStack.arrangedSubviews[0]
                    fruitStack.removeArrangedSubview(deletedView)
                    deletedView.removeFromSuperview()
                } while fruitStack.arrangedSubviews.count > fruit!
            }
        }
    }
    
    func updateActivity(activity: Int?, animated: Bool) {
        if activity != nil {
            day?.steps = Int64(activity!)
            if animated {
                // make the popup appear with appropriate message
                if activity! < settings.getTargetSteps() {
                    animatePopUp(headingText: "\(NSLocalizedString("Keep Going!", comment: " "))", descriptionText: "\(NSLocalizedString("You are only", comment: " ")) \(settings.getTargetSteps() - activity!) \(NSLocalizedString("steps away from your daily goal!", comment: " "))")
                } else if activity! == settings.getTargetSteps() {
                    animatePopUp(headingText: "\(NSLocalizedString("Congratulations!", comment: " "))", descriptionText: "\(NSLocalizedString("You have reached your daily goal of", comment: " ")) \(settings.getTargetSteps()) \(NSLocalizedString("steps", comment: " "))")
                } else {
                    animatePopUp(headingText: "\(NSLocalizedString("Congratulations!", comment: " "))", descriptionText: "\(NSLocalizedString("You have", comment: " ")) \(activity!  - settings.getTargetSteps()) \(NSLocalizedString("steps more than your goal!", comment: " "))")
                }
            }
            // update the day in persistent storage
            DayManager.sharedInstance.updateDay(day: day)
            setChart()
            
            activityLabel.text = "\(day!.steps)"
        }
    }
    
    func updateSleep(sleep: Double?, animated: Bool) {
        if sleep != nil {
            day?.sleep = sleep!
            if animated {
                // make the popup appear with appropriate message
                if sleep! < settings.getTargetSleep() {
                    animatePopUp(headingText: "\(NSLocalizedString("Catch Up!", comment: " "))", descriptionText: "\(NSLocalizedString("You may be a little behind on your sleep. Try to get to bed a little earlier!", comment: " "))")
                } else if sleep! == settings.getTargetSleep() {
                    animatePopUp(headingText: "\(NSLocalizedString("Congratulations!", comment: " "))", descriptionText: "\(NSLocalizedString("You reached your daily sleep goal!", comment: " "))")
                } else {
                    animatePopUp(headingText: "\(NSLocalizedString("Congratulations!", comment: " "))", descriptionText: "\(NSLocalizedString("Looks like you had a good night of sleep!", comment: " "))")
                }
            }
            // update the day in persistent storage
            DayManager.sharedInstance.updateDay(day: day)
            setChart()
            sleepLabel.text = "\(day!.sleep)"
        }
    }
    
    func updateWater(water: Int?, animated: Bool) {
        if water != nil {
            day?.water = Int64(water!)
            if animated {
                // make the popup appear with appropriate message
                if water! < settings.getTargetWater() {
                    animatePopUp(headingText: "\(NSLocalizedString("Keep Going!", comment: " "))", descriptionText: "\(NSLocalizedString("You are only", comment: " ")) \(settings.getTargetWater() - water!) \(NSLocalizedString("glasses of water away from your daily goal!", comment: " "))")
                } else if water! == settings.getTargetWater() {
                    animatePopUp(headingText: "\(NSLocalizedString("Congratulations!", comment: " "))", descriptionText: "\(NSLocalizedString("You have reached your daily goal of", comment: " ")) \(settings.getTargetWater()) \(NSLocalizedString("glasses of water!", comment: " "))")
                } else {
                    animatePopUp(headingText: "\(NSLocalizedString("Congratulations!", comment: " "))", descriptionText: "You have drank \(water!  - settings.getTargetWater()) \(NSLocalizedString("glasses of water more than your goal!", comment: " "))")
                }
            }
            // update the day in persistent storage
            DayManager.sharedInstance.updateDay(day: day)
            setChart()
            
            if waterStack.arrangedSubviews.count < water! {
                // add the neccessary amount of water images from the stack view
                repeat {
                    waterStack.addArrangedSubview(WaterImage())
                } while waterStack.arrangedSubviews.count < water!
            } else if waterStack.arrangedSubviews.count > water! {
                // remove the neccessary amount of water images from the stack view
                repeat{
                    let deletedView = waterStack.arrangedSubviews[0]
                    waterStack.removeArrangedSubview(deletedView)
                    deletedView.removeFromSuperview()
                } while waterStack.arrangedSubviews.count > water!
            }
        }
    }
    
    func animatePopUp(headingText: String, descriptionText: String) {
        // update the text on the pop up
        popUpHeader.text = headingText
        popUpDescription.text = descriptionText
        
        // fade in pop up, then fade out
        self.popUpTopConstraint.constant = 4
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: [], animations: { () -> Void in
            self.popUpView.alpha = 0.9
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.popUpTopConstraint.constant = -89
            UIView.animate(withDuration: 0.5, delay: 1.9, options: [.curveEaseIn], animations: { () -> Void in
                self.popUpView.alpha = 0.0
                
                self.view.layoutIfNeeded()
            }, completion: nil)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // set the delegate before you show a new view controller
        switch segue.identifier! {
        case "showMood":
            let destinationVC = segue.destination as! MoodViewController
            destinationVC.mDelegate = self
        case "showSleep":
            let destinationVC = segue.destination as! SleepViewController
            destinationVC.mDelegate = self
        case "showActivity":
            let destinationVC = segue.destination as! ActivityViewController
            destinationVC.mDelegate = self
        case "showWater":
            let destinationVC = segue.destination as! WaterViewController
            destinationVC.mDelegate = self
        case "showFruit":
            let destinationVC = segue.destination as! FruitViewController
            destinationVC.mDelegate = self
        case "showVegetables":
            let destinationVC = segue.destination as! VegetableViewController
            destinationVC.mDelegate = self
        default:
            break
        }
    }
    
    @IBAction func showMood(_ sender: UIButton) {
        // show the edit mood window
        performSegue(withIdentifier: "showMood", sender: self)
    }
    
    @IBAction func showSleep(_ sender: Any) {
        // show the edit sleep window
        performSegue(withIdentifier: "showSleep", sender: self)
    }
    
    @IBAction func showActivity(_ sender: UIButton) {
        // show the edit activity window
        performSegue(withIdentifier: "showActivity", sender: self)

    }
    
    @IBAction func showWater(_ sender: UIButton) {
        // show the edit water window
        performSegue(withIdentifier: "showWater", sender: self)

    }
    
    @IBAction func showFruit(_ sender: UIButton) {
        // show the edit fruit window
        performSegue(withIdentifier: "showFruit", sender: self)

    }
    
    @IBAction func showVegetables(_ sender: UIButton) {
        // show the edit vegetables window
        performSegue(withIdentifier: "showVegetables", sender: self)

    }
    
    @IBAction func switchToSunday(_ sender: UIButton) {
        // if day is available, switch to it
        if week[0] != nil {
            switchToDate(newDate: week[0]!)
        }
    }
    
    @IBAction func switchToMonday(_ sender: UIButton) {
        // if day is available, switch to it
        if week[1] != nil {
            switchToDate(newDate: week[1]!)
        }
    }
    
    @IBAction func switchToTuesday(_ sender: UIButton) {
        // if day is available, switch to it
        if week[2] != nil {
            switchToDate(newDate: week[2]!)
        }
    }
    
    @IBAction func switchToWednesday(_ sender: UIButton) {
        // if day is available, switch to it
        if week[3] != nil {
            switchToDate(newDate: week[3]!)
        }
    }
    
    @IBAction func switchToThursday(_ sender: UIButton) {
        // if day is available, switch to it
        if week[4] != nil {
            switchToDate(newDate: week[4]!)
        }
    }
    
    @IBAction func switchToFriday(_ sender: UIButton) {
        // if day is available, switch to it
        if week[5] != nil {
            switchToDate(newDate: week[5]!)
        }
    }
    
    @IBAction func switchToSaturday(_ sender: UIButton) {
        // if day is available, switch to it
        if week[6] != nil {
            switchToDate(newDate: week[6]!)
        }
    }
}
