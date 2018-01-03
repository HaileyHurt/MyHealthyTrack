//
//  ActivityViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/7/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class ActivityViewController : UIViewController, UITextFieldDelegate{
    @IBOutlet weak var healthkitLabel: UILabel!
    
    @IBOutlet weak var stepsTextField: UITextField!
    var mDelegate : ActivityProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let dayVC = mDelegate as! DayViewController? {
            // get the steps for today
            DayManager.sharedInstance.getStepsforDate(date: dayVC.day?.date! as! Date, completion: { (newSteps) in
                // set the labels to reflect the step values for today
                self.healthkitLabel.text = "\(NSLocalizedString("HealthKit says you have", comment: " ")) \(newSteps >= 0 ? newSteps : 0) \(NSLocalizedString("steps", comment: " "))"
                self.stepsTextField.placeholder = "\(dayVC.day!.steps >= 0 ? dayVC.day!.steps : 0)"
            })

        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        // Limit to only integer input and 9 digits
        let numberSet = NSCharacterSet(charactersIn: "0123456789").inverted
        let charsBySet = string.components(separatedBy: numberSet)
        let charsLeft = charsBySet.joined(separator: "")
        return charsLeft == string && newLength <= 9
    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        // tell delegate not to update steps, then dismiss
        mDelegate?.updateActivity(activity: nil, animated: false)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressSave(_ sender: UIButton) {
        if (stepsTextField.text?.isEmpty)! {
            // if text field is empty, dont update steps, then dismiss
            mDelegate?.updateActivity(activity: nil, animated: false)
            dismiss(animated: true, completion: nil)
        } else {
            // tell delegate to update steps, then dismiss
            mDelegate?.updateActivity(activity: Int(stepsTextField.text!), animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
}

// protocol for parent view controller
protocol ActivityProtocol: class
{
    func updateActivity(activity:Int?, animated:Bool)
}
