//
//  SettingsTableViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 12/11/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewController : UITableViewController {
    @IBOutlet weak var themeHeader: UILabel!
    @IBOutlet weak var themeDetail: UILabel!
    @IBOutlet weak var dayHeader: UILabel!
    @IBOutlet weak var dayDetail: UILabel!
    @IBOutlet weak var languageHeader: UILabel!
    
    @IBOutlet weak var themeTableCell: UITableViewCell!
    @IBOutlet weak var dayTableCell: UITableViewCell!
    @IBOutlet weak var languageTableCell: UITableViewCell!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorizeView()
        
        // set the label to show the current color theme
        if SettingsManager.sharedInstance.colorTheme.lightColor.isEqual(SettingsManager.sharedInstance.theBlues.lightColor) {
            themeDetail.text = NSLocalizedString("The Blues", comment: "")
        } else if SettingsManager.sharedInstance.colorTheme.lightColor.isEqual(SettingsManager.sharedInstance.stoneCold.lightColor) {
            themeDetail.text = NSLocalizedString("Stone Cold", comment: "")
        } else {
            themeDetail.text = NSLocalizedString("All Natural", comment: "") 
        }
        
        // Set the label to show the current first day
        switch SettingsManager.sharedInstance.getFirstDay() {
        case .sunday:
            dayDetail.text = NSLocalizedString("Sunday", comment: "")
        case .monday:
            dayDetail.text = NSLocalizedString("Monday", comment: "")
        case .tuesday:
            dayDetail.text = NSLocalizedString("Tuesday", comment: "")
        case .wednesday:
            dayDetail.text = NSLocalizedString("Wednesday", comment: "")
        case .thursday:
            dayDetail.text = NSLocalizedString("Thursday", comment: "")
        case .friday:
            dayDetail.text = NSLocalizedString("Friday", comment: "")
        case .saturday:
            dayDetail.text = NSLocalizedString("Saturday", comment: "")
        }
    }
    
    func colorizeView() {
        // color the view for the color theme
        tableView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().mediumColor
        
        tableView.separatorColor = SettingsManager.sharedInstance.getColorTheme().mediumColor
        
        themeHeader.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        themeDetail.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        dayHeader.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        dayDetail.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        languageHeader.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        
        themeTableCell.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        dayTableCell.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        languageTableCell.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
    }
}
