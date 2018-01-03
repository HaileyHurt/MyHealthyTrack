//
//  MoodViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/7/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

enum Mood: Double {
    case NoData = 0.0
    case VerySad = 0.2
    case Sad = 0.4
    case OK = 0.6
    case Happy = 0.8
    case VeryHappy = 1.0
}

class MoodViewController: UIViewController {
    var mDelegate : MoodProtocol?
    var moodVal: Mood = Mood.NoData
    
    @IBOutlet weak var verySadButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var veryHappyButton: UIButton!
    var currSelected: UIButton?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let dayVC = mDelegate as! DayViewController? {
            // set the selected mood to reflect the current selection if there is one
            let moodVal = Mood(rawValue: (dayVC.day?.mood)!)!
            switch moodVal {
            case .NoData:
                currSelected = nil
            case .VerySad:
                currSelected = verySadButton
                currSelected?.alpha = 1.0
            case .Sad:
                currSelected = sadButton
                currSelected?.alpha = 1.0
            case .OK:
                currSelected = okButton
                currSelected?.alpha = 1.0
            case .Happy:
                currSelected = happyButton
                currSelected?.alpha = 1.0
            case .VeryHappy:
                currSelected = veryHappyButton
                currSelected?.alpha = 1.0

            }
        }

    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        // dismiss the vc without saving
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressSave(_ sender: UIButton) {
        var imageView : UIImageView
        switch moodVal {
        case .VeryHappy:
            imageView = VeryHappyFaceImage()
        case .Happy:
            imageView = HappyFaceImage()
        case .OK:
            imageView = MediumFaceImage()
        case .Sad:
            imageView = SadFaceImage()
        case .VerySad:
            imageView = VerySadFaceImage()
        default:
            imageView = MediumFaceImage()
        }
        // send the moodval back to the delegate, then dismiss
        mDelegate?.updateMood(mood: moodVal, imageView: imageView)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressVerySad(_ sender: UIButton) {
        // set moodval and change its alpha to 1
        moodVal = .VerySad
        
        if currSelected != nil {
            currSelected?.alpha = 0.25
        }
        currSelected = sender
        currSelected?.alpha = 1.0
    }
    
    @IBAction func didPressSad(_ sender: UIButton) {
        // set moodval and change its alpha to 1
        moodVal = .Sad

        if currSelected != nil {
            currSelected?.alpha = 0.25
        }
        currSelected = sender
        currSelected?.alpha = 1.0
    }
    
    @IBAction func didPressOK(_ sender: UIButton) {
        // set moodval and change its alpha to 1
        moodVal = .OK

        if currSelected != nil {
            currSelected?.alpha = 0.25
        }
        currSelected = sender
        currSelected?.alpha = 1.0
    }
    
    @IBAction func didPressHappy(_ sender: UIButton) {
        // set moodval and change its alpha to 1
        moodVal = .Happy

        if currSelected != nil {
            currSelected?.alpha = 0.25
        }
        currSelected = sender
        currSelected?.alpha = 1.0
    }
    
    @IBAction func didPressVeryHappy(_ sender: UIButton) {
        // set moodval and change its alpha to 1
        moodVal = .VeryHappy
        
        if currSelected != nil {
            currSelected?.alpha = 0.25
        }
        currSelected = sender
        currSelected?.alpha = 1.0
    }
}

// protocol for parent view controller
protocol MoodProtocol: class
{
    func updateMood(mood:Mood, imageView: UIImageView)
}
