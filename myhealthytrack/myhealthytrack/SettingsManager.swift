//
//  SettingsManager.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/10/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar

class SettingsManager{
    static let sharedInstance = SettingsManager()

     let fruitString = "TargetFruit"
     let vegetableString = "TargetVegetables"
     let waterString = "TargetWater"
     let stepsString = "TargetSteps"
     let sleepString = "TargetSleep"
     let colorString = "ColorTheme"
     let firstDayString = "FirstDayOfWeek"

    private let defaultFruit = 2
    private let defaultVegetables = 3
    private let defaultWater = 8
    private let defaultSteps = 10000
    private let defaultSleep = 7.0

    private var targetVegetables: Int
    private var targetFruits: Int
    private var targetWater: Int
    private var targetSteps: Int
    private var targetSleep: Double
    
    private var defaults: UserDefaults
    
    struct ColorTheme {
        var lightColor : UIColor
        var mediumColor : UIColor
        var darkColor : UIColor
    }
    
    let theBlues : ColorTheme = ColorTheme(lightColor: UIColor.init(hex: "E6F4F7"), mediumColor: UIColor.init(hex: "21A4DA"), darkColor: UIColor.init(hex: "212A39"))

    let stoneCold : ColorTheme = ColorTheme(lightColor: UIColor.init(hex: "F3EDE6"), mediumColor: UIColor.init(hex: "C0BAB1"), darkColor: UIColor.init(hex: "3F3731"))

    let allNatural : ColorTheme = ColorTheme(lightColor: UIColor.init(hex: "FFF5CF"), mediumColor: UIColor.init(hex: "DBCDAD"), darkColor: UIColor.init(hex: "7F6854"))
    
    enum colorThemes {
        case theBlues 
        case stoneCold
        case allNatural
    }

    var colorTheme : ColorTheme
    private var firstDayOfWeek : Int
    
    init() {
        defaults = UserDefaults.standard
        
        // Load target vegetables from user defaults or set it to the default value
        if let targetVegetables = defaults.value(forKey: vegetableString) as! Int?{
            self.targetVegetables = targetVegetables
        } else {
            self.targetVegetables = defaultVegetables
            defaults.set(defaultVegetables, forKey: vegetableString)
        }
        
        // Load target fruits from user defaults or set it to the default value
        if let targetFruits = defaults.value(forKey: fruitString) as! Int?{
            self.targetFruits = targetFruits
        } else {
            self.targetFruits = defaultFruit
            defaults.set(defaultFruit, forKey: fruitString)
        }
        
        // Load target water from user defaults or set it to the default value
        if let targetWater = defaults.value(forKey: waterString) as! Int?{
            self.targetWater = targetWater
        } else {
            self.targetWater = defaultWater
            defaults.set(defaultWater, forKey: waterString)
        }
        
        // Load target steps from user defaults or set it to the default value
        if let targetSteps = defaults.value(forKey: stepsString) as! Int?{
            self.targetSteps = targetSteps
        } else {
            self.targetSteps = defaultSteps
            defaults.set(defaultSteps, forKey: stepsString)
        }
        
        // Load target sleep from user defaults or set it to the default value
        if let targetSleep = defaults.value(forKey: sleepString) as! Double?{
            self.targetSleep = targetSleep
        } else {
            self.targetSleep = defaultSleep
            defaults.set(defaultSleep, forKey: sleepString)
        }
        
        // Load first day of week from user defaults or set it to the default value
        if let firstDayOfWeek = defaults.value(forKey: firstDayString) as! Int?{
            self.firstDayOfWeek = firstDayOfWeek
        } else {
            self.firstDayOfWeek = 0
            defaults.set(self.firstDayOfWeek, forKey: firstDayString)
        }
        
        // Load color theme from user defaults or set it to the default value
        if let color = defaults.value(forKey: colorString) as! Int?{
            switch color {
            case 0:
                colorTheme = theBlues
            case 1:
                colorTheme = stoneCold
            default:
                colorTheme = allNatural
            }
        } else {
            self.colorTheme = theBlues
        }
    }
    
    func setTargetVegetables(newTarget: Int){
        targetVegetables = newTarget
        defaults.set(newTarget, forKey: vegetableString)
    }
    
    func setTargetFruit(newTarget: Int){
        targetFruits = newTarget
        defaults.set(newTarget, forKey: fruitString)
    }
    
    func setTargetWater(newTarget: Int){
        targetWater = newTarget
        defaults.set(newTarget, forKey: waterString)
    }
    
    func setTargetSteps(newTarget: Int){
        targetSteps = newTarget
        defaults.set(newTarget, forKey: stepsString)
    }
    
    func setTargetSleep(newTarget: Double){
        targetSleep = newTarget
        defaults.set(newTarget, forKey: sleepString)
    }
    
    func setTargetColorTheme(newTheme : colorThemes){
        // Set integer value for color theme into user defaults
        switch newTheme {
        case .theBlues:
            colorTheme = theBlues
            defaults.set(0, forKey: colorString)
        case .stoneCold:
            colorTheme = stoneCold
            defaults.set(1, forKey: colorString)
        case .allNatural:
            colorTheme = allNatural
            defaults.set(2, forKey: colorString)
        }
    }
    
    func setFirstDay(newTarget: DaysOfWeek){
        // Set integer value for the first day into user defaults
        switch newTarget {
        case .sunday:
            firstDayOfWeek = 0
            defaults.set(firstDayOfWeek, forKey: firstDayString)
        case .monday:
            firstDayOfWeek = 1
            defaults.set(firstDayOfWeek, forKey: firstDayString)
        case .tuesday:
            firstDayOfWeek = 2
            defaults.set(firstDayOfWeek, forKey: firstDayString)
        case .wednesday:
            firstDayOfWeek = 3
            defaults.set(firstDayOfWeek, forKey: firstDayString)
        case .thursday:
            firstDayOfWeek = 4
            defaults.set(firstDayOfWeek, forKey: firstDayString)
        case .friday:
            firstDayOfWeek = 5
            defaults.set(firstDayOfWeek, forKey: firstDayString)
        case .saturday:
            firstDayOfWeek = 6
            defaults.set(firstDayOfWeek, forKey: firstDayString)
        }
        
    }
    
    func getTargetVegetables() -> Int {
        return targetVegetables
    }
    
    func getTargetFruit() -> Int {
        return targetFruits
    }
    
    func getTargetWater() -> Int {
        return targetWater
    }
    
    func getTargetSteps() -> Int {
        return targetSteps
    }
    
    func getTargetSleep() -> Double {
        return targetSleep
    }
    
    func getColorTheme() -> ColorTheme {
        return colorTheme
    }
    
    func getFirstDay() -> DaysOfWeek {
        // Return DayOfWeek value
        switch firstDayOfWeek {
        case 0:
            return DaysOfWeek.sunday
        case 1:
            return DaysOfWeek.monday
        case 2:
            return DaysOfWeek.tuesday
        case 3:
            return DaysOfWeek.wednesday
        case 4:
            return DaysOfWeek.thursday
        case 5:
            return DaysOfWeek.friday
        case 6:
            return DaysOfWeek.saturday
        default:
            return DaysOfWeek.sunday
        }
    }
    
    // Set the goal values, color theme, and first day back to the original values
    func restoreDefaults() {
        setTargetFruit(newTarget: defaultFruit)
        setTargetSleep(newTarget: defaultSleep)
        setTargetSteps(newTarget: defaultSteps)
        setTargetWater(newTarget: defaultWater)
        setTargetVegetables(newTarget: defaultVegetables)
        
        setTargetColorTheme(newTheme: .theBlues)
        setFirstDay(newTarget: .sunday)
    }
}
