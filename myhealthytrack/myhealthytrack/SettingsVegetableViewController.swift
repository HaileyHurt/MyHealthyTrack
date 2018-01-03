//
//  SettingsVegetableViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/22/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class SettingsVegetableViewController: UIViewController {
    var mDelegate : SettingsVegetableProtocol?
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add vegetable images for every current vegetable
        for _ in 0..<SettingsManager.sharedInstance.getTargetVegetables(){
            stackView.addArrangedSubview(VegetableImage())
        }
    }
    
    @IBAction func didPressSave(_ sender: UIButton) {
        // tell delegate ot update vegetables, then dismiss
        mDelegate?.updateVegetables(vegetables: stackView.arrangedSubviews.count)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        // tell delegate to not update vegetables, then dismiss
        mDelegate?.updateVegetables(vegetables: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addVegetable(_ sender: UIButton) {
        // add a vegetable image to the stack view
        stackView.addArrangedSubview(VegetableImage())
    }
    
    @IBAction func removeVegetable(_ sender: UIButton) {
        // remove one vegetable image from the stack view
        if stackView.arrangedSubviews.count > 0{
            let deletedView = stackView.arrangedSubviews[0]
            stackView.removeArrangedSubview(deletedView)
            deletedView.removeFromSuperview()
            
        }
    }
}

// protocol for parent view controller
protocol SettingsVegetableProtocol: class
{
    func updateVegetables(vegetables:Int?)
}

