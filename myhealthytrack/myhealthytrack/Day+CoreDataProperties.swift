//
//  Day+CoreDataProperties.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/14/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var fruit: Int64
    @NSManaged public var mood: Double
    @NSManaged public var sleep: Double
    @NSManaged public var steps: Int64
    @NSManaged public var vegetables: Int64
    @NSManaged public var water: Int64
    @NSManaged public var date: NSDate?

}
