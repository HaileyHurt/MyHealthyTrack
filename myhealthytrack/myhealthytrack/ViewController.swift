//
//  ViewController.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 10/31/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Charts
import HealthKit

class ViewController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var switchView: UIView!        
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var previousMonthButton: UIButton!
    
    @IBOutlet weak var dailyGoalLabel: UILabel!
    @IBOutlet weak var hundredPercentLabel: UILabel!
    @IBOutlet weak var zeroPercentLabel: UILabel!
    @IBOutlet weak var topLegendView: UIView!
    @IBOutlet weak var bottomLegendView: UIView!
    
    @IBOutlet weak var moodSwitch: UISwitch!
    @IBOutlet weak var sleepSwitch: UISwitch!
    @IBOutlet weak var activitySwitch: UISwitch!
    @IBOutlet weak var waterSwitch: UISwitch!
    @IBOutlet weak var fruitSwitch: UISwitch!
    @IBOutlet weak var vegetableSwitch: UISwitch!
   
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var fruitLabel: UILabel!
    @IBOutlet weak var veggieLabel: UILabel!
    
    @IBOutlet weak var daysOfWeekStack: UIStackView!
    
    var lastView : UIViewController?
    
    var testCalendar = Calendar.current
    let settings = SettingsManager.sharedInstance
    
    // Dates currently selected
    var rangeSelectedDates: [Date] = []
    
    var moodDataSet: LineChartDataSet!
    var sleepDataSet: LineChartDataSet!
    var activityDataSet: LineChartDataSet!
    var waterDataSet: LineChartDataSet!
    var fruitDataSet: LineChartDataSet!
    var vegetableDataSet: LineChartDataSet!
    var emptyDataSet: LineChartDataSet!

    var chartData: LineChartData!
    
    var targetDate : Date?

    let formatter : DateFormatter = {
        // Configure the date formatter
        let df = DateFormatter()
        df.dateFormat = "yyyy MM dd"
        df.timeZone = Calendar.current.timeZone
        df.locale = Calendar.current.locale
        
        return df
    }()
    
    enum chartDataType{
        case mood
        case sleep
        case activity
        case water
        case fruits
        case vegetables
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // the target data is today
        targetDate = Date()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // create the data entries for the chart
        var dataEntriesMood: [ChartDataEntry] = [ChartDataEntry]()
        var dataEntriesSleep: [ChartDataEntry] = [ChartDataEntry]()
        var dataEntriesActivity: [ChartDataEntry] = [ChartDataEntry]()
        var dataEntriesWater: [ChartDataEntry] = [ChartDataEntry]()
        var dataEntriesFruit: [ChartDataEntry] = [ChartDataEntry]()
        var dataEntriesVegetables: [ChartDataEntry] = [ChartDataEntry]()
        var emptyEntries: [ChartDataEntry] = [ChartDataEntry]()
        
        // configure the data sets for the chart
        moodDataSet = LineChartDataSet(values: dataEntriesMood, label: " ")
        moodDataSet.mode = .horizontalBezier
        setUpChartData(dataSet: moodDataSet, color: UIColor.init(hex: "CC56BE"))
        sleepDataSet = LineChartDataSet(values: dataEntriesSleep, label: " ")
        sleepDataSet.mode = .horizontalBezier
        setUpChartData(dataSet: sleepDataSet, color: UIColor.lightGray)
        activityDataSet = LineChartDataSet(values: dataEntriesActivity, label: " ")
        activityDataSet.mode = .horizontalBezier
        setUpChartData(dataSet: activityDataSet, color: UIColor.init(hex: "EB6158"))
        waterDataSet = LineChartDataSet(values: dataEntriesWater, label: " ")
        waterDataSet.mode = .horizontalBezier
        setUpChartData(dataSet: waterDataSet, color: UIColor.init(hex: "00A4B2"))
        fruitDataSet = LineChartDataSet(values: dataEntriesFruit, label: " ")
        fruitDataSet.mode = .horizontalBezier
        setUpChartData(dataSet: fruitDataSet, color: UIColor.init(hex: "FF9A52"))
        vegetableDataSet = LineChartDataSet(values: dataEntriesVegetables, label: " ")
        vegetableDataSet.mode = .horizontalBezier
        setUpChartData(dataSet: vegetableDataSet, color: UIColor.init(hex: "52E87E"))
        emptyDataSet = LineChartDataSet(values: emptyEntries, label: " ")
        emptyDataSet.mode = .horizontalBezier
        setUpChartData(dataSet: emptyDataSet, color: UIColor.clear)

        // initialize the properties of the chart
        chartView.autoScaleMinMaxEnabled = false
        chartView.scaleXEnabled = false
        let rightYAxis : YAxis = chartView.leftAxis
        let leftYAxis : YAxis = chartView.rightAxis
        rightYAxis.axisMinimum = 0.0;
        rightYAxis.axisMaximum = 1.0;
        chartView.borderColor = UIColor.clear
        chartView.borderLineWidth = 0.0
        chartView.chartDescription = nil
        chartView.chartDescription?.text = ""
        chartView.drawBordersEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawMarkers = false
        rightYAxis.drawAxisLineEnabled = false
        rightYAxis.drawGridLinesEnabled = false
        rightYAxis.drawLabelsEnabled = false
        leftYAxis.drawAxisLineEnabled = false
        leftYAxis.drawGridLinesEnabled = false
        leftYAxis.drawLabelsEnabled = false
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.legend.enabled = false
        
        initializeChart()
        
        // Only proceed if health data is available.
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let typesToRead = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        
        // request to use the users steps from healthkit
        DayManager.sharedInstance.healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if !success{
                if let error = error  {
                    print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error.localizedDescription). If you're using a simulator, try it on a device.")
                }
            }
        }
        
        // finish initializations
        clearChart()
        colorizeView()
        scrollCalendar(date: targetDate!)
    }
    
    func colorizeView() {
        // color view according to the color theme
        mainView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().mediumColor
        
        chartView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        calendarView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        switchView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        
        nextMonthButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: UIControlState.normal)
        previousMonthButton.setTitleColor(SettingsManager.sharedInstance.getColorTheme().lightColor, for: UIControlState.normal)
        monthYearLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        
        hundredPercentLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        zeroPercentLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        dailyGoalLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        topLegendView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        bottomLegendView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor

        sundayLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        mondayLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        tuesdayLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        wednesdayLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        thursdayLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        fridayLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        saturdayLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor

        moodLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        sleepLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        stepsLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        waterLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        fruitLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        veggieLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
        
        // arrange the days of week labels in proper order according to the first day of weej
        switch settings.getFirstDay() {
            case .sunday:
                daysOfWeekStack.insertArrangedSubview(sundayLabel, at: 0)
                daysOfWeekStack.insertArrangedSubview(mondayLabel, at: 1)
                daysOfWeekStack.insertArrangedSubview(tuesdayLabel, at: 2)
                daysOfWeekStack.insertArrangedSubview(wednesdayLabel, at: 3)
                daysOfWeekStack.insertArrangedSubview(thursdayLabel, at: 4)
                daysOfWeekStack.insertArrangedSubview(fridayLabel, at: 5)
                daysOfWeekStack.insertArrangedSubview(saturdayLabel, at: 6)
            case .monday:
                daysOfWeekStack.insertArrangedSubview(mondayLabel, at: 0)
                daysOfWeekStack.insertArrangedSubview(tuesdayLabel, at: 1)
                daysOfWeekStack.insertArrangedSubview(wednesdayLabel, at: 2)
                daysOfWeekStack.insertArrangedSubview(thursdayLabel, at: 3)
                daysOfWeekStack.insertArrangedSubview(fridayLabel, at: 4)
                daysOfWeekStack.insertArrangedSubview(saturdayLabel, at: 5)
                daysOfWeekStack.insertArrangedSubview(sundayLabel, at: 6)
            case .tuesday:
                daysOfWeekStack.insertArrangedSubview(tuesdayLabel, at: 0)
                daysOfWeekStack.insertArrangedSubview(wednesdayLabel, at: 1)
                daysOfWeekStack.insertArrangedSubview(thursdayLabel, at: 2)
                daysOfWeekStack.insertArrangedSubview(fridayLabel, at: 3)
                daysOfWeekStack.insertArrangedSubview(saturdayLabel, at: 4)
                daysOfWeekStack.insertArrangedSubview(sundayLabel, at: 5)
                daysOfWeekStack.insertArrangedSubview(mondayLabel, at: 6)
            case .wednesday:
                daysOfWeekStack.insertArrangedSubview(wednesdayLabel, at: 0)
                daysOfWeekStack.insertArrangedSubview(thursdayLabel, at: 1)
                daysOfWeekStack.insertArrangedSubview(fridayLabel, at: 2)
                daysOfWeekStack.insertArrangedSubview(saturdayLabel, at: 3)
                daysOfWeekStack.insertArrangedSubview(sundayLabel, at: 4)
                daysOfWeekStack.insertArrangedSubview(mondayLabel, at: 5)
                daysOfWeekStack.insertArrangedSubview(tuesdayLabel, at: 6)
            case .thursday:
                daysOfWeekStack.insertArrangedSubview(thursdayLabel, at: 0)
                daysOfWeekStack.insertArrangedSubview(fridayLabel, at: 1)
                daysOfWeekStack.insertArrangedSubview(saturdayLabel, at: 2)
                daysOfWeekStack.insertArrangedSubview(sundayLabel, at: 3)
                daysOfWeekStack.insertArrangedSubview(mondayLabel, at: 4)
                daysOfWeekStack.insertArrangedSubview(tuesdayLabel, at: 5)
                daysOfWeekStack.insertArrangedSubview(wednesdayLabel, at: 6)
            case .friday:
                daysOfWeekStack.insertArrangedSubview(fridayLabel, at: 0)
                daysOfWeekStack.insertArrangedSubview(saturdayLabel, at: 1)
                daysOfWeekStack.insertArrangedSubview(sundayLabel, at: 2)
                daysOfWeekStack.insertArrangedSubview(mondayLabel, at: 3)
                daysOfWeekStack.insertArrangedSubview(tuesdayLabel, at: 4)
                daysOfWeekStack.insertArrangedSubview(wednesdayLabel, at: 5)
                daysOfWeekStack.insertArrangedSubview(thursdayLabel, at: 6)
            case .saturday:
                daysOfWeekStack.insertArrangedSubview(saturdayLabel, at: 0)
                daysOfWeekStack.insertArrangedSubview(sundayLabel, at: 1)
                daysOfWeekStack.insertArrangedSubview(mondayLabel, at: 2)
                daysOfWeekStack.insertArrangedSubview(tuesdayLabel, at: 3)
                daysOfWeekStack.insertArrangedSubview(wednesdayLabel, at: 4)
                daysOfWeekStack.insertArrangedSubview(thursdayLabel, at: 5)
                daysOfWeekStack.insertArrangedSubview(fridayLabel, at: 6)
        }
        
        // update date and title
        updateTitle()
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month], from: Date())
        let startOfMonth = Calendar.current.date(from: components)!
        calendarView.scrollToDate(targetDate!, triggerScrollToDateDelegate: true, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0.0, completionHandler: nil)
        
        if targetDate! >= startOfMonth {
            // if it is the current month, then disable the next month button
            nextMonthButton.isUserInteractionEnabled = false
            nextMonthButton.alpha = 0
        } else {
            // not current month, allow the user to go to the next month
            nextMonthButton.isUserInteractionEnabled = true
            nextMonthButton.alpha = 1
        }
        
        dailyGoalLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        // set all switches to active
        moodSwitch.setOn(true, animated: false)
        sleepSwitch.setOn(true, animated: false)
        activitySwitch.setOn(true, animated: false)
        waterSwitch.setOn(true, animated: false)
        fruitSwitch.setOn(true, animated: false)
        vegetableSwitch.setOn(true, animated: false)
    }
    
    override func viewDidLoad() {
        navigationController?.delegate = self

        // long press gesture to select dates in the calenda
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(_:)))
        lpgr.minimumPressDuration = 0.0
        lpgr.allowableMovement = 999
        lpgr.delaysTouchesBegan = false
        lpgr.cancelsTouchesInView = false
        lpgr.delegate = self
        calendarView.addGestureRecognizer(lpgr)
        
        // calendar view configuration
        calendarView.allowsMultipleSelection = true
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        chartView.noDataText = "\(NSLocalizedString("Select dates to view your progress.", comment: " "))"
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // make the old view disappear and call func
        if lastView != nil {
            lastView?.viewWillDisappear(animated)
        }
        
        // make the new view appear and call func
        viewController.viewWillAppear(animated)
        lastView = viewController
    }
    
    func initializeChart(){
        // configure the chart with initial parameters
        chartData = LineChartData(dataSets: [moodDataSet, sleepDataSet, activityDataSet, waterDataSet, fruitDataSet, vegetableDataSet, emptyDataSet])
        chartView.backgroundColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        chartView.data = chartData
        
        _ = emptyDataSet.addEntryOrdered(ChartDataEntry(x: Double(0.0), y: 0.0))

        colorizeView()
    }
    
    func setUpChartData(dataSet: LineChartDataSet, color: UIColor) {
        //configure the data set for the chart
        dataSet.colors = [color]
        dataSet.circleColors = [color]
        dataSet.circleHoleRadius = 0
        dataSet.drawValuesEnabled = false
    }
    
    func colorizeCalendarCells(view : JTAppleCell?, cellState : CellState){
        guard let validCell = view as? CalendarDayCell else {return}
        
        if cellState.isSelected == false{
            if cellState.date > Date() {
                // future dates should be un-selectable
                validCell.dateLabel.textColor = SettingsManager.sharedInstance.getColorTheme().mediumColor
                validCell.isUserInteractionEnabled = false
            } else if cellState.dateBelongsTo == .thisMonth {
                // date of this month are visible
                validCell.dateLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
            } else {
                // dates from other months are invisible
                validCell.dateLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
            }
        }
    }
    

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        // Initial start and end for calendar
        let startDate = formatter.date(from: "2000 01 01")!
        let endDate = Date()
        
        // Calendar with no in-dates and out-dates
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: nil, calendar: nil, generateInDates: InDateCellGeneration.forAllMonths, generateOutDates: OutDateCellGeneration.off, firstDayOfWeek: settings.getFirstDay(), hasStrictBoundaries: true)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        // Set the date of the cell
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        cell.dateLabel.text = cellState.text
        
        // color the cell depending on whether its selected
        if calendarView.selectedDates.contains(cellState.date) {
            cell.selectedView.isHidden = false
            cell.dateLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor

        } else {
            cell.selectedView.isHidden = true
            cell.dateLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor

        }
        
        // recolor the cell
        colorizeCalendarCells(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func getDateRange(cellState : CellState) -> [Date?]{
        var dateSet : [Date?] = [Date?]()
        var currDate = cellState.date
        
        // loop back until you reach the first Sunday
        while true {
            if Calendar.current.component(.weekday, from: currDate) <= 1 {
                break
            }
            currDate = currDate.yesterday
        }
        // currdate is Sunday
        currDate = Calendar.current.startOfDay(for: currDate)

        while true {
            // add the rest of the days of the week unless they havent happened yet
            if currDate <= Date() {
                dateSet.append(currDate)
            } else {
                dateSet.append(nil)
            }
            if Calendar.current.component(.weekday, from: currDate) >= 7 {
                // break after we've reached saturday
                break
            }
            currDate = currDate.tomorrow
            currDate = Calendar.current.startOfDay(for: currDate)
        }
        // return the week
        return dateSet
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "toSettings" {
            // Get dayVC and set its date
            let dayVC = segue.destination as! DayViewController
            let cellState = sender as! CellState
            let cell = cellState.cell() as! CalendarDayCell
            cell.dateLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
            cell.selectedView.isHidden = true
            
            // send information to day view controller
            let newDate = Calendar.current.startOfDay(for: cellState.date)
            dayVC.day = DayManager.sharedInstance.getDayForDate(date: newDate)
            dayVC.week = getDateRange(cellState: cellState)
            dayVC.currSelectedIndex = Calendar.current.component(.weekday, from: cellState.date) - 1

        }
        
    }
    
    func addDayToChart(date: Date, day: Day){
        if(day.mood > 0.0){
            // if the mood value is set, add it to the chart
            addPointToChart(date: date, chartType: .mood, value: day.mood)
        }
        
        if(day.sleep >= 0.0){
            // if the sleep value is set, add it to the chart
            addPointToChart(date: date, chartType: .sleep, value: day.sleep)
        }
        
        if(day.steps >= 0){
            // if the steps value is set, add it to the chart
            addPointToChart(date: date, chartType: .activity, value: Double(day.steps))
        }
        
        if(day.water >= 0){
            // if the water value is set, add it to the chart
            addPointToChart(date: date, chartType: .water, value: Double(day.water))
        }
        
        if(day.fruit >= 0){
            // if the fruit value is set, add it to the chart
            addPointToChart(date: date, chartType: .fruits, value: Double(day.fruit))
        }
        
        if(day.vegetables >= 0){
            // if the vegetable value is set, add it to the chart
            addPointToChart(date: date, chartType: .vegetables, value: Double(day.vegetables))
        }
        if let index = calendarView.selectedDates.index(of: date) {

            _ = emptyDataSet.addEntryOrdered(ChartDataEntry(x: Double(index), y: 0.0))
            chartData.notifyDataChanged()
            chartView.notifyDataSetChanged()
            if(index > 0){
                chartView.setVisibleXRange(minXRange: Double(index), maxXRange: Double(index))
            }
        }
    }
    
    func addPointToChart(date: Date, chartType: chartDataType, value: Double){
        // add the value to the appropriate data set
        if let index = calendarView.selectedDates.index(of: date) {
            switch chartType{
            case .mood:
                _ = moodDataSet.addEntryOrdered(ChartDataEntry(x: Double(index), y: value))
            case .sleep:
                _ = sleepDataSet.addEntryOrdered(ChartDataEntry(x: Double(index), y: value/Double(settings.getTargetSleep())))
            case .activity:
                _ = activityDataSet.addEntryOrdered(ChartDataEntry(x: Double(index), y: value/Double(settings.getTargetSteps())))
            case .water:
                _ = waterDataSet.addEntryOrdered(ChartDataEntry(x: Double(index), y: value/Double(settings.getTargetWater())))
            case .fruits:
                _ = fruitDataSet.addEntryOrdered(ChartDataEntry(x: Double(index), y: value/Double(settings.getTargetFruit())))
            case .vegetables:
                _ = vegetableDataSet.addEntryOrdered(ChartDataEntry(x: Double(index), y: value/Double(settings.getTargetVegetables())))
                
            }
            
            // redraw the chart
            
            
        }
    }
    
    func removeDayFromChart(date: Date, day: Day, index: Int){
        var shouldRedraw : Bool = false
        if(day.mood > 0.0){
            // if there is a mood value, delete it
            _ = moodDataSet.removeEntry(moodDataSet.entryForXValue(Double(index), closestToY: 0.5)!)
            shouldRedraw = true
        }
        
        if(day.sleep >= 0.0){
            // if there is a sleep value, delete it
            _ = sleepDataSet.removeEntry(sleepDataSet.entryForXValue(Double(index), closestToY: 0.5)!)
            shouldRedraw = true
        }
        
        if(day.steps >= 0){
            // if there is a steps value, delete it
            _ = activityDataSet.removeEntry(activityDataSet.entryForXValue(Double(index), closestToY: 0.5)!)
            shouldRedraw = true
        }
        
        if(day.water >= 0){
            // if there is a water value, delete it
            _ = waterDataSet.removeEntry(waterDataSet.entryForXValue(Double(index), closestToY: 0.5)!)
            shouldRedraw = true
        }
        
        if(day.fruit >= 0){
            // if there is a fruit value, delete it
            _ = fruitDataSet.removeEntry(fruitDataSet.entryForXValue(Double(index), closestToY: 0.5)!)
            shouldRedraw = true
        }
        
        if(day.vegetables >= 0){
            // if there is a vegetable value, delete it
            _ = vegetableDataSet.removeEntry(vegetableDataSet.entryForXValue(Double(index), closestToY: 0.5)!)
            shouldRedraw = true
        }
        
        // redraw the chart
        if shouldRedraw {
            chartData.notifyDataChanged()
            chartView.notifyDataSetChanged()
        }
        
        _ = emptyDataSet.removeEntry(x: Double(index))
        if(index > 1){
            chartView.setVisibleXRange(minXRange: Double(index - 1), maxXRange: Double(index - 1))
        }
    }
    
    func clearChart(){
        // delete all of the data for the chart
        moodDataSet.clear()
        sleepDataSet.clear()
        activityDataSet.clear()
        waterDataSet.clear()
        fruitDataSet.clear()
        vegetableDataSet.clear()
        emptyDataSet.clear()
        emptyDataSet.addEntryOrdered(ChartDataEntry(x: 0.0, y: 0.0))
    }
    
    @objc func didStartRangeSelecting(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began{
            // new range, clear old chart
            clearChart()

            let badDates : [Date] = calendarView.selectedDates
            calendarView.deselectAllDates(triggerSelectionDelegate: false)
            for d in badDates {
                if let cell : JTAppleCell = calendarView.cellStatus(for: d)?.cell() {
                    // deselct all previously selected dates
                    let dayCell = cell as! CalendarDayCell
                    dayCell.dateLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
                    dayCell.selectedView.isHidden = true
                }
            }
        }
        
        // find which cell was selected
        let point = gesture.location(in: gesture.view!)
        rangeSelectedDates = calendarView.selectedDates
        if let cellState = calendarView.cellStatus(at: point) {
            // make sure the cell should be able to be selected
            if cellState.dateBelongsTo == .thisMonth &&  cellState.date <= Date() {
                let date = cellState.date

                if !calendarView.selectedDates.contains(date) {
                    // select all dates between the previous date and the new date
                    let dateRange = calendarView.generateDateRange(from: calendarView.selectedDates.first ?? date, to: date)
                    for aDate in dateRange {
                        if !rangeSelectedDates.contains(aDate) {
                            rangeSelectedDates.append(aDate)
                            calendarView.selectDates(from: aDate, to: aDate, keepSelectionIfMultiSelectionAllowed: true)
                            let newDate = Calendar.current.startOfDay(for: aDate)
                            
                            // get the day data for this date and add it to the chat
                            let day = DayManager.sharedInstance.getDayForDate(date: newDate)
                            addDayToChart(date: aDate, day: day)
                            if(day.steps == -1 || Calendar.current.isDateInToday(aDate)){
                                // if the steps havent been set or its today, ask healthkit for steps
                                DayManager.sharedInstance.getStepsforDate(date: newDate, completion: { (newVal) in
                                    if Calendar.current.isDateInToday(newDate) {
                                        if newVal > Double(day.steps) {
                                            //if its today and the new step value is greater than the old step calue, update the day with the new steps
                                            self.addPointToChart(date: aDate, chartType: .activity, value: newVal)
                                            day.steps = Int64(newVal)
                                            day.date = Calendar.current.startOfDay(for: newDate) as NSDate
                                            DayManager.sharedInstance.updateDay(day: day)
                                        }
                                    } else {
                                        // use the healthkit data and assign it to this day and update the day
                                        self.addPointToChart(date: aDate, chartType: .activity, value: newVal)
                                        day.steps = Int64(newVal)
                                        day.date = Calendar.current.startOfDay(for: newDate) as NSDate
                                        DayManager.sharedInstance.updateDay(day: day)
                                    }
                                    
                                })
                            }
                        }
                    }

                } else {
                    // date was already selected, so we will deselect it
                    let indexOfNewlySelectedDate = rangeSelectedDates.index(of: date)! + 1
                    let lastIndex = rangeSelectedDates.endIndex
                    let followingDay = testCalendar.date(byAdding: .day, value: 1, to: date)!
                    calendarView.selectDates(from: followingDay, to: rangeSelectedDates.last!, keepSelectionIfMultiSelectionAllowed: false)
                    rangeSelectedDates.removeSubrange(indexOfNewlySelectedDate..<lastIndex)
                }
            }
        }
        
        if gesture.state == .ended {
            if rangeSelectedDates.count == 1 {
                calendarView.cellStatus(for: rangeSelectedDates.first!, completionHandler: { (state) in
                    self.performSegue(withIdentifier: "showDay", sender: state)
                })
            }
            rangeSelectedDates.removeAll()

            var dates : [String] = [String]()
            var values : [Double] = [Double]()
            formatter.dateFormat = "dd"

            for i in 0..<calendarView.selectedDates.count {
                dates.append(formatter.string(from: calendarView.selectedDates[i]))
                values.append(Double(arc4random_uniform(100)))
            }
            formatter.dateFormat = "yyyy MM dd"
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        // only allow selection for cells in the current month
        if cellState.dateBelongsTo == .thisMonth {
            return true
        } else {
            return false
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if rangeSelectedDates.isEmpty{
            // we are starting to select a new range
           var badDates : [Date] = calendarView.selectedDates
            if let da = badDates.index(of: date){
                // remove the newly selected date from the calendarviews selecteddates
                badDates.remove(at: da)
            }
            
            // deselect all of the previously selected dates
            calendarView.deselect(dates: badDates, triggerSelectionDelegate: false)
            for d in badDates {
                calendarView.cellStatus(for: d, completionHandler: { (cs) in
                    if let oldCell = cs?.cell() {
                        // unselect the cell and color it back to normal
                        let dayCell = oldCell as! CalendarDayCell
                        dayCell.dateLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
                        dayCell.selectedView.isHidden = true
                    }
                })
            }

        }
        
        guard let validCell = cell as? CalendarDayCell else {
            // if the cell is not valid then ignore and return
            return
        }
        
        // make the selection in the calendar view and recolor is
        calendarView.selectItem(at: calendarView.indexPath(for: validCell), animated: false, scrollPosition: UICollectionViewScrollPosition.top)
        validCell.selectedView.isHidden = false
        validCell.dateLabel.textColor = SettingsManager.sharedInstance.getColorTheme().lightColor
        
        if date == calendarView.selectedDates.first {
            // The first date should have round edge on the left
            let path = UIBezierPath(roundedRect:validCell.selectedView.bounds, byRoundingCorners:[.bottomLeft, .topLeft, .bottomRight, .topRight], cornerRadii: CGSize(width: 50, height:  50))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            validCell.selectedView.layer.mask = maskLayer
        } else if date == calendarView.selectedDates.last{
            // the last date should have rounded edges on the right
            let path = UIBezierPath(roundedRect:validCell.selectedView.bounds, byRoundingCorners:[.bottomRight, .topRight], cornerRadii: CGSize(width: 50, height:  50))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            validCell.selectedView.layer.mask = maskLayer
            
            if calendarView.selectedDates.count > 2{
                // the previous date used to have rounded edges, make them straight again
                let prevDate : Date = calendarView.selectedDates[calendarView.selectedDates.count - 2]
                let prevCell : CalendarDayCell = calendarView.cellStatus(for: prevDate)?.cell() as! CalendarDayCell
                let path = UIBezierPath(roundedRect:prevCell.selectedView.bounds, byRoundingCorners:[], cornerRadii: CGSize(width: 50, height:  50))
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                prevCell.selectedView.layer.mask = maskLayer
            } else if calendarView.selectedDates.count == 2{
                // the first cell used to have rounded edges on both sides, now only on left side
                let prevDate : Date = calendarView.selectedDates.first!
                let prevCell : CalendarDayCell = calendarView.cellStatus(for: prevDate)?.cell() as! CalendarDayCell
                let path = UIBezierPath(roundedRect:prevCell.selectedView.bounds, byRoundingCorners:[.bottomLeft, .topLeft], cornerRadii: CGSize(width: 50, height:  50))
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                prevCell.selectedView.layer.mask = maskLayer
            }
        }

    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if (cell as! CalendarDayCell).selectedView.isHidden == false && calendarView.selectedDates.count == 0 {
            // go to the selected day
            performSegue(withIdentifier: "showDay", sender: cellState)
            return
        }
        
        guard let validCell = cell as? CalendarDayCell else {
            // if the cell isn't valid then ignore and return
            return
        }
        
        if let index = rangeSelectedDates.index(of: date) {
            // if the date has already been selected, remove it
            let newDate = Calendar.current.startOfDay(for: date)
            removeDayFromChart(date: date, day: DayManager.sharedInstance.getDayForDate(date: newDate), index: index)
        }
        
        if calendarView.selectedDates.count > 1 && rangeSelectedDates.count < 2{
            // deselect and reselect the dates
            calendarView.deselectAllDates()
            calendarView.selectDates([date])
        } else {
            // unselect this cell
            validCell.selectedView.isHidden = true
            validCell.dateLabel.textColor = SettingsManager.sharedInstance.getColorTheme().darkColor
            
            if(calendarView.selectedDates.count > 1){
                // change the view on the cell before to be a rounded on the right side
                let prevDate : Date = calendarView.selectedDates.last!
                guard let prevCell : CalendarDayCell = (calendarView.cellStatus(for: prevDate)?.cell() as! CalendarDayCell) else { return }
                let path = UIBezierPath(roundedRect:prevCell.selectedView.bounds, byRoundingCorners:[.bottomRight, .topRight], cornerRadii: CGSize(width: 50, height:  50))
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                prevCell.selectedView.layer.mask = maskLayer
            } else if calendarView.selectedDates.count == 1 {
                // there is only one cell seleced so round it on all 4 corners
                let prevDate : Date = calendarView.selectedDates.first!
                let prevCell : CalendarDayCell = calendarView.cellStatus(for: prevDate)?.cell() as! CalendarDayCell
                let path = UIBezierPath(roundedRect:prevCell.selectedView.bounds, byRoundingCorners:[.bottomRight, .topRight, .bottomLeft, .topLeft], cornerRadii: CGSize(width: 50, height:  50))
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                prevCell.selectedView.layer.mask = maskLayer
            }
        }
    }
    
    func updateTitle () {
        // update the title for the target date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        monthYearLabel.text = "\(dateFormatter.string(from: targetDate!))"
    }
    
    func scrollCalendar(date : Date) {
        // update view to new date
        print("Scrolling to date: \(date)")

        calendarView.scrollToDate(date)
        updateTitle()
        
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month], from: Date())
        let startOfMonth = Calendar.current.date(from: components)!
        if targetDate! >= startOfMonth {
            // if it is the current month, don't let the user go to next month
            nextMonthButton.isUserInteractionEnabled = false
            nextMonthButton.alpha = 0
        } else {
            // its not the current month, so let the user go to next month
            nextMonthButton.isUserInteractionEnabled = true
            nextMonthButton.alpha = 1
        }
    }
    
    @IBAction func showNextMonth(_ sender: UIButton) {
        // find the date one month from now
        var dateComponents = DateComponents()
        dateComponents.month = 1
        targetDate = Calendar.current.date(byAdding: dateComponents, to: targetDate!)
        
        scrollCalendar(date: targetDate!)
    }
    
    @IBAction func showPreviousMonth(_ sender: UIButton) {
        // find the date from one month ago
        var dateComponents = DateComponents()
        dateComponents.month = -1
        targetDate = Calendar.current.date(byAdding: dateComponents, to: targetDate!)
        
        scrollCalendar(date: targetDate!)
    }
    
    @IBAction func toggleMood(_ sender: UISwitch) {
        // toggle the visibility of the mood data
        if moodSwitch.isOn {
            moodDataSet.colors = [UIColor.init(hex: "CC56BE")]
            moodDataSet.circleColors = [UIColor.init(hex: "CC56BE")]
        } else {
            moodDataSet.colors = [UIColor.clear]
            moodDataSet.circleColors = [UIColor.clear]
        }
        
        // redraw chart
        chartData.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    @IBAction func toggleSleep(_ sender: UISwitch) {
        // toggle the visibility of the sleep data
        if sleepSwitch.isOn {
            sleepDataSet.colors = [UIColor.lightGray]
            sleepDataSet.circleColors = [UIColor.lightGray]
        } else {
            sleepDataSet.colors = [UIColor.clear]
            sleepDataSet.circleColors = [UIColor.clear]
        }
        
        // redraw chart
        chartData.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    @IBAction func toggleActivity(_ sender: UISwitch) {
        // toggle the visibility of the activity data
        if activitySwitch.isOn {
            activityDataSet.colors = [UIColor.init(hex: "EB6158")]
            activityDataSet.circleColors = [UIColor.init(hex: "EB6158")]
        } else {
            activityDataSet.colors = [UIColor.clear]
            activityDataSet.circleColors = [UIColor.clear]
        }
        
        // redraw chart
        chartData.notifyDataChanged()
        chartView.notifyDataSetChanged()
        
    }
    
    @IBAction func toggleWater(_ sender: UISwitch) {
        // toggle the visibility of the water data
        if waterSwitch.isOn {
            waterDataSet.colors = [UIColor.init(hex: "00A4B2")]
            waterDataSet.circleColors = [UIColor.init(hex: "00A4B2")]
        } else {
            waterDataSet.colors = [UIColor.clear]
            waterDataSet.circleColors = [UIColor.clear]
        }
        
        // redraw chart
        chartData.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    @IBAction func toggleFruit(_ sender: Any) {
        // toggle the visibility of the fruit data
        if fruitSwitch.isOn {
            fruitDataSet.colors = [UIColor.init(hex: "FF9A52")]
            fruitDataSet.circleColors = [UIColor.init(hex: "FF9A52")]
        } else {
            fruitDataSet.colors = [UIColor.clear]
            fruitDataSet.circleColors = [UIColor.clear]
        }
        
        // redraw chart
        chartData.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    @IBAction func toggleVegetables(_ sender: UISwitch) {
        // toggle the visibility of the vegetable data
        if vegetableSwitch.isOn {
            vegetableDataSet.colors = [UIColor.init(hex: "52E87E")]
            vegetableDataSet.circleColors = [UIColor.init(hex: "52E87E")]
        } else {
            vegetableDataSet.colors = [UIColor.clear]
            vegetableDataSet.circleColors = [UIColor.clear]
        }
        
        // redraw chart
        chartData.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
}

// extend UIColor class to have a hex initializer
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

// extend date class to get more relative values
extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}
