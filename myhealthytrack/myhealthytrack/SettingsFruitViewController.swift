//
//  SettingsFruitViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/22/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class SettingsFruitViewController: UIViewController {
    var mDelegate : SettingsFruitProtocol?
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add fruit image for every current fruit
        for _ in 0..<SettingsManager.sharedInstance.getTargetFruit(){
            stackView.addArrangedSubview(FruitImage())
        }
    }
    
    @IBAction func didPressSave(_ sender: UIButton) {
        // tell delegate to update fruit, then dismiss vc
        mDelegate?.updateFruit(fruit: stackView.arrangedSubviews.count)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        // tell delegate not to update fruit, then dismiss vc
        mDelegate?.updateFruit(fruit: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFruit(_ sender: UIButton) {
        // add a fruit image to the stack
        stackView.addArrangedSubview(FruitImage())
    }
    
    @IBAction func removeFruit(_ sender: UIButton) {
        // remove a fruit image from the stack
        if stackView.arrangedSubviews.count > 0{
            let deletedView = stackView.arrangedSubviews[0]
            stackView.removeArrangedSubview(deletedView)
            deletedView.removeFromSuperview()
            
        }
    }
}

// protocol for parent view controller
protocol SettingsFruitProtocol: class
{
    func updateFruit(fruit:Int?)
}

