//
//  SettingsManagerTests.swift
//  
//
//  Created by Hailey Hurt on 12/21/17.
//

import XCTest
import Foundation
import CoreData
@testable import myhealthytrack
import JTAppleCalendar

class SettingsManagerTests: XCTestCase {
    
    func testDefaults() {
        UserDefaults.blankDefaultsWhile {
            let sut = SettingsManager()
            
            XCTAssertEqual(sut.getTargetSleep() , 7.0)
            XCTAssertEqual(sut.getTargetSteps() , 10000)
            XCTAssertEqual(sut.getTargetFruit() , 2)
            XCTAssertEqual(sut.getTargetVegetables() , 3)
            XCTAssertEqual(sut.getTargetWater() , 8)
            XCTAssertEqual(sut.getFirstDay().rawValue ,
                           1)
            XCTAssertEqual(sut.colorTheme.lightColor, sut.theBlues.lightColor)
        }
    }
    
    func testSleep() {
        UserDefaults.blankDefaultsWhile {
            let sut = SettingsManager()
            
            sut.setTargetSleep(newTarget: 18.0)
            XCTAssertEqual(sut.getTargetSleep(), 18.0)
        }
    }
    
    func testActivity() {
        UserDefaults.blankDefaultsWhile {
            let sut = SettingsManager()
            
            sut.setTargetSteps(newTarget: 3000)
            XCTAssertEqual(sut.getTargetSteps(), 3000)
        }
    }
    
    func testFruit() {
        UserDefaults.blankDefaultsWhile {
            let sut = SettingsManager()
            
            sut.setTargetFruit(newTarget: 8)
            XCTAssertEqual(sut.getTargetFruit(), 8)
        }
    }
    
    func testVegetables() {
        UserDefaults.blankDefaultsWhile {
            let sut = SettingsManager()
            
            sut.setTargetVegetables(newTarget: 5)
            XCTAssertEqual(sut.getTargetVegetables(), 5)
        }
    }
    
    func testWater() {
        UserDefaults.blankDefaultsWhile {
            let sut = SettingsManager()
            
            sut.setTargetWater(newTarget: 13)
            XCTAssertEqual(sut.getTargetWater(), 13)
        }
    }
    
    func testFirstDayOfWeek() {
        UserDefaults.blankDefaultsWhile {
            let sut = SettingsManager()
            
            sut.setFirstDay(newTarget: DaysOfWeek.tuesday)
            XCTAssertEqual(sut.getFirstDay(), DaysOfWeek.tuesday)
        }
    }
    
    func testColorTheme() {
        UserDefaults.blankDefaultsWhile {
            let sut = SettingsManager()
            
            sut.setTargetColorTheme(newTheme: SettingsManager.colorThemes.allNatural)
            XCTAssertEqual(sut.getColorTheme().lightColor, sut.allNatural.lightColor)
        }
    }
}

extension UserDefaults {
    static func blankDefaultsWhile(handler:()->Void){
        guard let name = Bundle.main.bundleIdentifier else {
            fatalError("Couldn't find bundle ID.")
        }
        let old = UserDefaults.standard.persistentDomain(forName: name)
        defer {
            UserDefaults.standard.setPersistentDomain( old ?? [:],
                                      forName: name)
        }
        
        UserDefaults.standard.removePersistentDomain(forName: name)
        handler()
    }
}
