//
//  WaterViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/8/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class WaterViewController: UIViewController {
    var mDelegate : WaterProtocol?

    @IBOutlet weak var stackView: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add a fruit image for every current fruit
        if let dayVC = mDelegate as! DayViewController?{
            if (dayVC.day?.water)! > 0 {
                for _ in 0..<Int(exactly: (dayVC.day?.water)!)!{
                    stackView.addArrangedSubview(WaterImage())
                }
            }
        }
    }
    
    @IBAction func didPressSave(_ sender: UIButton) {
        // tell delegate to update water, then dismiss
        mDelegate?.updateWater(water: stackView.arrangedSubviews.count, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        // tell delegate not to update water, then dismiss
        mDelegate?.updateWater(water: nil, animated: false)
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

// protocol for parent view controller
protocol WaterProtocol: class
{
    func updateWater(water:Int?, animated:Bool)
}
