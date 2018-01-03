//
//  FruitViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/8/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class FruitViewController: UIViewController{
    var mDelegate : FruitProtocol?

    @IBOutlet weak var stackView: UIStackView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add a fruit image for every current fruit
        if let dayVC = mDelegate as! DayViewController? {
            if (dayVC.day?.fruit)! > 0 {
                for _ in 0..<Int(exactly: (dayVC.day?.fruit)!)!{
                    stackView.addArrangedSubview(FruitImage())
                }
            }
        }
    }
    
    @IBAction func didPressSave(_ sender: UIButton) {
        // tell delegate to update fruit, then dismiss
        mDelegate?.updateFruit(fruit: stackView.arrangedSubviews.count, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressCancel(_ sender: Any) {
        // tell delegate not to update fruit, then dismiss
        mDelegate?.updateFruit(fruit: nil, animated: false)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFruit(_ sender: UIButton) {
        // add a fruit image to the stack view
        stackView.addArrangedSubview(FruitImage())

    }
    
    @IBAction func removeFruit(_ sender: UIButton) {
        // remove a fruit image from the stack view
        if stackView.arrangedSubviews.count > 0{
            let deletedView = stackView.arrangedSubviews[0]
            stackView.removeArrangedSubview(deletedView)
            deletedView.removeFromSuperview()
            
        }
    }
}

// protocol for parent view controller
protocol FruitProtocol: class
{
    func updateFruit(fruit:Int?, animated:Bool)
}
