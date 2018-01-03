//
//  VegetableViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/8/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class VegetableViewController: UIViewController {
    var mDelegate : VegetableProtocol?

    @IBOutlet weak var stackView: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add a vegetable image for every current vegetable
        if let dayVC = mDelegate as! DayViewController? {
            if (dayVC.day?.vegetables)! > 0 {
                for _ in 0..<Int(exactly: (dayVC.day?.vegetables)!)! {
                    stackView.addArrangedSubview(VegetableImage())
                }
            }
        }
    }
    
    @IBAction func didPressSave(_ sender: UIButton) {
        // tell delegate to update vegetable, then dismiss
        mDelegate?.updateVegetables(vegetables: stackView.arrangedSubviews.count, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        // tell delegate not to update vegetable, then dismiss
        mDelegate?.updateVegetables(vegetables: nil, animated: false)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addVegetable(_ sender: UIButton) {
        // add a vegetable image to the stack view
        stackView.addArrangedSubview(VegetableImage())
    }
    
    @IBAction func removeVegetable(_ sender: UIButton) {
        // remove a vegetable image from the stack view
        if stackView.arrangedSubviews.count > 0{
            let deletedView = stackView.arrangedSubviews[0]
            stackView.removeArrangedSubview(deletedView)
            deletedView.removeFromSuperview()
            
        }
    }
}

// protocol for parent view controller
protocol VegetableProtocol: class
{
    func updateVegetables(vegetables:Int?, animated:Bool)
}
