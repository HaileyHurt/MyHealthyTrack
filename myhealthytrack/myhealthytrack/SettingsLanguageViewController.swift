//
//  SettingsLanguageViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 12/15/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class SettingsLanguageViewController: UIViewController, UIActionSheetDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var restoreButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        colorizeView()
    }
    
    func colorizeView() {
        // color view according to color theme
        mainView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().mediumColor
        
        selectLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        
        restoreButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().mediumColor, for: .normal)
        restoreButton.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
    }
    
    @IBAction func doRestore(_ sender: Any) {
        // create an alert controller to confirm that they want to
        let actionSheet = UIAlertController(title: NSLocalizedString("Restore Settings", comment: ""), message: NSLocalizedString("Are you sure you want to restore settings?", comment: ""), preferredStyle: .actionSheet)
        
        // set sourcerect for ipad devices
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: mainView.bounds.size.width/2 - 150, y: 0, width: 300, height: 200)
        actionSheet.popoverPresentationController?.sourceView = mainView
        let cancelActionButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
            
        }
        actionSheet.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: NSLocalizedString("Restore", comment: ""), style: .default)
        { _ in
            // if they confirm, then restore defaults and recolor the view
            SettingsManager.sharedInstance.restoreDefaults()
            
            self.colorizeView()
        }
        actionSheet.addAction(saveActionButton)
        
        // show the alert controller
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}
