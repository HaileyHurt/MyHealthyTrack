//
//  SettingsActivityViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/22/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class SettingsActivityViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var healthkitLabel: UILabel!
    
    @IBOutlet weak var stepsTextField: UITextField!
    var mDelegate : SettingsActivityProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set placeholder to show current target steps
        stepsTextField.placeholder = "\(SettingsManager.sharedInstance.getTargetSteps())"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        // Limit length to 9 digits
        let newLength = text.count + string.count - range.length
        
        // Limit to only integer input
        let numberSet = NSCharacterSet(charactersIn: "0123456789").inverted
        let charsBySet = string.components(separatedBy: numberSet)
        let charsLeft = charsBySet.joined(separator: "")
        return charsLeft == string && newLength <= 9
    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        // tell delegate not to update steps, then dismiss
        mDelegate?.updateActivity(activity: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressSave(_ sender: UIButton) {
        if (stepsTextField.text?.isEmpty)! {
            // if text field is empty, dont update steps, then dismiss
            mDelegate?.updateActivity(activity: nil)
            dismiss(animated: true, completion: nil)
        } else {
            // tell delegate to update steps, then dismiss
            mDelegate?.updateActivity(activity: Int(stepsTextField.text!))
            dismiss(animated: true, completion: nil)
        }
    }
}

// protocol for parent view controller
protocol SettingsActivityProtocol: class
{
    func updateActivity(activity:Int?)
}
