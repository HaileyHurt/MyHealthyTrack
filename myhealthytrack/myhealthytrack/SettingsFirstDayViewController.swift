//
//  SettingsFirstDayViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 12/15/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class SettingsFirstDayViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var selectLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorizeView()
    }
    
    func colorizeView() {
        // color according to color theme
        mainView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().mediumColor
        
        selectLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
    }
}
