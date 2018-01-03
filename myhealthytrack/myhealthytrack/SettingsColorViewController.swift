//
//  SettingsColorViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 12/15/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class SettingsColorViewController: UIViewController, SettingsColorThemeTableViewControllerProtocol{
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "colorTable" {
            // set self as delegate for the table in container view
            let containerViewViewController = segue.destination as! SettingsColorThemeTableViewController
            
            containerViewViewController.delegate = self
        }
    }
}
