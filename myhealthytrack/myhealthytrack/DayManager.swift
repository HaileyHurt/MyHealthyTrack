//
//  DayManager.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 11/13/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import Foundation
import CoreData
import HealthKit
import UIKit

class DayManager {
    static let sharedInstance = DayManager()
    let healthStore = HKHealthStore()
    
    var persistentContainer : NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    private convenience init(){
        //
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    func getDayForDate(date: Date) -> Day {
        //Fetch request to find day from core data
        let fetchRequest : NSFetchRequest<Day> = Day.fetchRequest()
        let predicate = NSPredicate(format: "date == %@", date as CVarArg)
        fetchRequest.predicate = predicate
        
        // execute fetch request to get day for date
        var fetchedDays: [Day]?
        persistentContainer.viewContext.performAndWait {
            fetchedDays = try? fetchRequest.execute()
        }
        
        // if there was already a day in core data, return it
        if let existingDay = fetchedDays?.first{
            return existingDay
        }
        
        // create a new day and store it persistently
        var day: Day!
        persistentContainer.viewContext.performAndWait {
            // set default values for new day
            day =  Day(context: persistentContainer.viewContext)
            day.date = date as NSDate
            day.steps = -1
            day.mood = 0.0
            day.sleep = -1
            day.fruit = -1
            day.vegetables = -1
            day.water = -1
            
            // save new day
            do{
                try DayManager.sharedInstance.persistentContainer.viewContext.save()
            } catch {
                print("Error saving to core data: \(error)")
            }
        }
        // return new day
        return day
    }
    
    func getStepsforDate(date: Date, completion: @escaping (Double) -> Void) {
        print("Getting steps for: \(date)")
        //   Define the Step Quantity Type
        let stepsCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        //   Get the start of the day
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate = cal.startOfDay(for: date)
        
        //  Set the Predicates & Interval
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        var interval = DateComponents()
        interval.day = 1
        
        // Get range for today
        var todayFirst = Calendar.current.startOfDay(for: date)
        var todayLast : Date? {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: todayFirst)
            
        }
        let predicate = HKQuery.predicateForSamples(withStart: todayFirst, end: todayLast, options: .strictStartDate)
        
        // Healthkit query to fetch steps for day
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            
            guard let result = result else {
                print("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        // perform query
        healthStore.execute(query)
    }
    
    func updateDay(day: Day?){
        // Fetch request to find the specific day from CoreData
        let fetchRequest : NSFetchRequest<Day> = Day.fetchRequest()
        let predicate = NSPredicate(format: "date == %@", day?.date! as! NSDate)
        fetchRequest.predicate = predicate
        
        var fetchedDays: [Day]?
        DayManager.sharedInstance.persistentContainer.viewContext.performAndWait {
            fetchedDays = try? fetchRequest.execute()
            // Get the day instance fromCoreData
            if let updatedDay = fetchedDays?.first {
                // update values of the persistent day
                updatedDay.mood = (day?.mood)!
                updatedDay.sleep = (day?.sleep)!
                updatedDay.steps = (day?.steps)!
                updatedDay.fruit = (day?.fruit)!
                updatedDay.vegetables = (day?.vegetables)!
                updatedDay.water = (day?.water)!
            }
            
            // Save day to persistent storage
            do{
                try DayManager.sharedInstance.persistentContainer.viewContext.save()
            } catch {
                print("Error saving to core data: \(error)")
            }
        }
    }
}
