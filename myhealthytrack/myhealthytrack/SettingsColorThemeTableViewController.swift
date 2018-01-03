//
//  SettingsColorThemeTableViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 12/15/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class SettingsColorThemeTableViewController: UITableViewController {
    @IBOutlet weak var bluesLabel: UILabel!
    @IBOutlet weak var stoneColdLabel: UILabel!
    @IBOutlet weak var allNaturalLabel: UILabel!
    
    @IBOutlet weak var bluesCell: UITableViewCell!
    @IBOutlet weak var stoneColdCell: UITableViewCell!
    @IBOutlet weak var allNaturalCell: UITableViewCell!
    
    // will be parent view controller
    var delegate : SettingsColorThemeTableViewControllerProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the proper color theme to be selected
        switch SettingsManager.sharedInstance.getColorTheme().lightColor {
        case SettingsManager.sharedInstance.theBlues.lightColor:
            tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.top)
            bluesCell.accessoryType = .checkmark
        case SettingsManager.sharedInstance.stoneCold.lightColor:
            tableView.selectRow(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.top)
            stoneColdCell.accessoryType = .checkmark
        default:
            tableView.selectRow(at: IndexPath(row: 2, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.top)
            allNaturalCell.accessoryType = .checkmark
        }
        // color view for color theme
        colorizeView()
    }
    
    func colorizeView() {
        // Recolor the view
        tableView.separatorColor = SettingsManager.sharedInstance.getColorTheme().mediumColor
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // check mark newly selected cell
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            
        }
        
        // Set the color theme in persistent storage
        switch indexPath.row {
        case 0:
            SettingsManager.sharedInstance.setTargetColorTheme(newTheme: SettingsManager.colorThemes.theBlues)
        case 1:
            SettingsManager.sharedInstance.setTargetColorTheme(newTheme: SettingsManager.colorThemes.stoneCold)
        default:
            SettingsManager.sharedInstance.setTargetColorTheme(newTheme: SettingsManager.colorThemes.allNatural)
        }
        // Re color this view and parent of container view
        self.delegate?.colorizeView()
        colorizeView()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // uncheck previously selected cell
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
}

// Protocol for parent view controller
protocol SettingsColorThemeTableViewControllerProtocol {
    func colorizeView()
}

