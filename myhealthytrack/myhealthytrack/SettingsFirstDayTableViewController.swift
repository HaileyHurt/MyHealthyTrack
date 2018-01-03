//
//  SettingsFirstDayTableViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 12/15/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit
import JTAppleCalendar

class SettingsFirstDayTableViewController: UITableViewController {
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tuesLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thursLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    
    @IBOutlet weak var sunCell: UITableViewCell!
    @IBOutlet weak var monCell: UITableViewCell!
    @IBOutlet weak var tuesCell: UITableViewCell!
    @IBOutlet weak var wedCell: UITableViewCell!
    @IBOutlet weak var thursCell: UITableViewCell!
    @IBOutlet weak var friCell: UITableViewCell!
    @IBOutlet weak var satCell: UITableViewCell!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // color view according to color theme
        sunCell.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        monCell.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        tuesCell.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        wedCell.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        thursCell.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        friCell.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        satCell.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        
        tableView.separatorColor = SettingsManager.sharedInstance.getColorTheme().mediumColor

        sunLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        monLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        tuesLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        wedLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        thursLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        friLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        satLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        
        // set the current first day cell to be selected
        switch SettingsManager.sharedInstance.getFirstDay() {
        case .sunday:
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.top)
            sunCell.accessoryType = .checkmark
        case .monday:
            tableView.selectRow(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.top)
            monCell.accessoryType = .checkmark
        case .tuesday:
            tableView.selectRow(at: IndexPath(row: 2, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.top)
            tuesCell.accessoryType = .checkmark
        case .wednesday:
            tableView.selectRow(at: IndexPath(row: 3, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.top)
            wedCell.accessoryType = .checkmark
        case .thursday:
            tableView.selectRow(at: IndexPath(row: 4, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.top)
            thursCell.accessoryType = .checkmark
        case .friday:
            tableView.selectRow(at: IndexPath(row: 5, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.top)
            friCell.accessoryType = .checkmark
        case .saturday:
            tableView.selectRow(at: IndexPath(row: 6, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.top)
            satCell.accessoryType = .checkmark
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // checkmark the newly selected cell
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            
        }
        
        //set the first day value to persistent storage
        switch indexPath.row {
        case 0:
            SettingsManager.sharedInstance.setFirstDay(newTarget: DaysOfWeek.sunday)
        case 1:
            SettingsManager.sharedInstance.setFirstDay(newTarget: DaysOfWeek.monday)
        case 2:
            SettingsManager.sharedInstance.setFirstDay(newTarget: DaysOfWeek.tuesday)
        case 3:
            SettingsManager.sharedInstance.setFirstDay(newTarget: DaysOfWeek.wednesday)
        case 4:
            SettingsManager.sharedInstance.setFirstDay(newTarget: DaysOfWeek.thursday)
        case 5:
            SettingsManager.sharedInstance.setFirstDay(newTarget: DaysOfWeek.friday)
        case 6:
            SettingsManager.sharedInstance.setFirstDay(newTarget: DaysOfWeek.saturday)
        default:
            SettingsManager.sharedInstance.setFirstDay(newTarget: DaysOfWeek.sunday)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //uncheck previously selected cell
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    
    
}
