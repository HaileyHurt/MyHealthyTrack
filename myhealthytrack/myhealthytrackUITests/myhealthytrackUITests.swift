//
//  myhealthytrackUITests.swift
//  myhealthytrackUITests
//
//  Created by Hailey Hurt on 10/31/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import XCTest

class myhealthytrackUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testColorThemes() {
        let app = XCUIApplication()
        app.navigationBars["My Healthy Track"].buttons["Settings"].tap()
        
        app.tables.staticTexts["Color Theme"].tap()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["The Blues"]/*[[".cells.staticTexts[\"The Blues\"]",".staticTexts[\"The Blues\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Stone Cold"]/*[[".cells.staticTexts[\"Stone Cold\"]",".staticTexts[\"Stone Cold\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["All Natural"]/*[[".cells.staticTexts[\"All Natural\"]",".staticTexts[\"All Natural\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["myhealthytrack.SettingsColorView"].buttons["Settings"].tap()
        XCTAssertTrue(tablesQuery.staticTexts["All Natural"].exists)
    }
    
    func testFirstDay() {
        XCTAssertEqual(0, 0)
        
        let app = XCUIApplication()
        app.navigationBars["My Healthy Track"].buttons["Settings"].tap()
        
        app.tables.staticTexts["Start of Week"].tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Wednesday"].tap()
        app.navigationBars["myhealthytrack.SettingsFirstDayView"].buttons["Settings"].tap()
        XCTAssertTrue(tablesQuery.staticTexts["Wednesday"].exists)

        app.navigationBars["Settings"].buttons["Calendar >"].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["Wed"].coordinate(withNormalizedOffset: CGVector.zero).screenPoint.x < XCUIApplication().staticTexts["Tue"].coordinate(withNormalizedOffset: CGVector.zero).screenPoint.x)
        XCTAssertTrue(XCUIApplication().staticTexts["Wed"].coordinate(withNormalizedOffset: CGVector.zero).screenPoint.x < XCUIApplication().staticTexts["Thu"].coordinate(withNormalizedOffset: CGVector.zero).screenPoint.x)
    }
    
    func testReset() {
        XCTAssertEqual(0, 0)
        
        let app = XCUIApplication()
        app.navigationBars["My Healthy Track"].buttons["Settings"].tap()
        
        app.tables.staticTexts["Restore Settings"].tap()
        app.buttons["Restore Settings"].tap()
        app.sheets["Restore Settings"].buttons["Restore"].tap()
        app.navigationBars["myhealthytrack.SettingsLanguageView"].buttons["Settings"].tap()
        XCTAssertTrue(app.tables.staticTexts["Sunday"].exists)
        XCTAssertTrue(app.tables.staticTexts["The Blues"].exists)


        app.navigationBars["Settings"].buttons["Calendar >"].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["Sun"].coordinate(withNormalizedOffset: CGVector.zero).screenPoint.x < XCUIApplication().staticTexts["Sat"].coordinate(withNormalizedOffset: CGVector.zero).screenPoint.x)
        XCTAssertTrue(XCUIApplication().staticTexts["Sun"].coordinate(withNormalizedOffset: CGVector.zero).screenPoint.x < XCUIApplication().staticTexts["Mon"].coordinate(withNormalizedOffset: CGVector.zero).screenPoint.x)
    }
}
