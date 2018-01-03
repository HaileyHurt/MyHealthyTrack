//
//  DayManagerTests.swift
//  myhealthytrackUITests
//
//  Created by Hailey Hurt on 12/24/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import XCTest
import CoreData
@testable import myhealthytrack

class DayManagerTests: XCTestCase {
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "MyHealthyTrack", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDayDefaults(){
        let sut = DayManager(container: mockPersistantContainer)

        let day = sut.getDayForDate(date: Date())
        XCTAssertEqual(day.mood, 0.0)
        XCTAssertEqual(day.sleep, -1)
        XCTAssertEqual(day.steps, -1)
        XCTAssertEqual(day.water, -1)
        XCTAssertEqual(day.fruit, -1)
        XCTAssertEqual(day.vegetables, -1)
    }
    
    func testDayUpdate() {
        let sut = DayManager(container: mockPersistantContainer)
        
        let day = sut.getDayForDate(date: Date().yesterday)
        
        day.mood = 1.0
        day.sleep = 7.0
        day.steps = 6000
        day.water = 12
        day.fruit = 4
        day.vegetables = 1

        XCTAssertEqual(day.mood, 1.0)
        XCTAssertEqual(day.sleep, 7.0)
        XCTAssertEqual(day.steps, 6000)
        XCTAssertEqual(day.water, 12)
        XCTAssertEqual(day.fruit, 4)
        XCTAssertEqual(day.vegetables, 1)
        
    }
}
