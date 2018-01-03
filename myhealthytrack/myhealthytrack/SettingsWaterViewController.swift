//
//  SettingsWaterViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/22/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class SettingsWaterViewController: UIViewController {
    var mDelegate : SettingsWaterProtocol?
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add a water image for every current water
        for _ in 0..<SettingsManager.sharedInstance.getTargetWater(){
                stackView.addArrangedSubview(WaterImage())
        }
    }
    
    @IBAction func didPressSave(_ sender: UIButton) {
        // tell delegate to update water, then dismiss vc
        mDelegate?.updateWater(water: stackView.arrangedSubviews.count)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        // tell delegate not to update water, then dismiss vc
        mDelegate?.updateWater(water: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addWater(_ sender: UIButton) {
        // add a water image to the stack view
        stackView.addArrangedSubview(WaterImage())
    }
    
    @IBAction func removeWater(_ sender: UIButton) {
        // remove a water image from the stack view
        if stackView.arrangedSubviews.count > 0{
            let deletedView = stackView.arrangedSubviews[0]
            stackView.removeArrangedSubview(deletedView)
            deletedView.removeFromSuperview()
            
        }
    }
}

// delegate for parent view controller
protocol SettingsWaterProtocol: class
{
    func updateWater(water:Int?)
}
