//
//  SettingsSleepViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/22/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class SettingsSleepViewController: UIViewController {
    var sleepVal: Double!
    var mDelegate : SettingsSleepProtocol?
    
    @IBOutlet weak var sleepHoursLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set value to current target sleep
        sleepHoursLabel.text = String(format: "%.2f", SettingsManager.sharedInstance.getTargetSleep())

    }
    
    @IBAction func didPressSave(_ sender: UIButton) {
        // tell delegate to update sleep, then dismiss
        mDelegate?.updateSleep(sleep: sleepVal)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        // tell delegate not to update sleep, then dismiss
        mDelegate?.updateSleep(sleep: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressUp(_ sender: UIButton) {
        // increase the value by .25
        sleepVal = Double(sleepHoursLabel.text!)
        if(sleepVal < 24){
            sleepVal! += 0.25
            sleepHoursLabel.text = String(format: "%.2f", sleepVal)
        }
    }
    
    @IBAction func didPressDown(_ sender: UIButton) {
        // Decrease the value by .25
        sleepVal = Double(sleepHoursLabel.text!)
        if(sleepVal > 0){
            sleepVal! -= 0.25
            sleepHoursLabel.text = String(format: "%.2f", sleepVal)
        }
    }
}

// protocol for parent view controller
protocol SettingsSleepProtocol: class
{
    func updateSleep(sleep:Double?)
}
