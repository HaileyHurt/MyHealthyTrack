//
//  SleepViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/7/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class SleepViewController: UIViewController {
    var sleepVal: Double!
    var mDelegate : SleepProtocol?

    @IBOutlet weak var sleepHoursLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let dayVC = mDelegate as! DayViewController? {
            sleepVal = dayVC.day?.sleep
            if sleepVal > 0 {
                // if the sleep val has been set, set that value to the label
                sleepHoursLabel.text = String(format: "%.2f", sleepVal)
            } else {
                // if the sleep value hasn't been set, use the target value on the label
                sleepVal = SettingsManager.sharedInstance.getTargetSleep()
                sleepHoursLabel.text = String(format: "%.2f", sleepVal)
            }
        }
    }
    
    @IBAction func didPressSave(_ sender: UIButton) {
        // tell delegate to update sleep, then dismiss
        mDelegate?.updateSleep(sleep: sleepVal, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        // tell delegate not to update sleep, then dismiss
        mDelegate?.updateSleep(sleep: nil, animated: false)
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
protocol SleepProtocol: class
{
    func updateSleep(sleep:Double?, animated:Bool)
}

