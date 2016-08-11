//
//  Day.swift
//  Tester
//
//  Created by Will Webberley on 02/05/2016.
//  Copyright © 2016 Will Webberley. All rights reserved.
//

import Foundation
import SQLite

class Day {
    
    var date, sunrise, sunset: NSDate
    let calendar = NSCalendar.currentCalendar()
    var tideEvents = [TideEvent]()
    
    init(date: NSDate, cursor: Row){
        let timeParseFormatter = NSDateFormatter()
        timeParseFormatter.dateFormat = "h:m a"
        timeParseFormatter.locale = NSLocale(localeIdentifier: "en_GB_POSIX")
        
        self.date = date
        self.sunrise = Day.getDate(timeParseFormatter, cursor: cursor, key: "sunrise")!
        self.sunset = Day.getDate(timeParseFormatter, cursor: cursor, key: "sunset")!
        
        let high1Time: NSDate? = Day.getDate(timeParseFormatter, cursor: cursor, key: "high1_time")
        if (high1Time != nil){
            tideEvents.append(TideEvent(day: self, type: "high", height: Day.getDouble(cursor, key: "high1_height")!, time: high1Time!))
        }
        let low1Time: NSDate? = Day.getDate(timeParseFormatter, cursor: cursor, key: "low1_time")
        if (low1Time != nil){
            tideEvents.append(TideEvent(day: self, type: "low", height: Day.getDouble(cursor, key: "low1_height")!, time: low1Time!))
        }
        let high2Time: NSDate? = Day.getDate(timeParseFormatter, cursor: cursor, key: "high2_time")
        if (high2Time != nil){
            tideEvents.append(TideEvent(day: self, type: "high", height: Day.getDouble(cursor, key: "high2_height")!, time: high2Time!))
        }
        let low2Time: NSDate? = Day.getDate(timeParseFormatter, cursor: cursor, key: "low2_time")
        if (low2Time != nil){
            tideEvents.append(TideEvent(day: self, type: "low", height: Day.getDouble(cursor, key: "low2_height")!, time: low2Time!))
        }
        let high3Time: NSDate? = Day.getDate(timeParseFormatter, cursor: cursor, key: "high3_time")
        if (high3Time != nil){
            tideEvents.append(TideEvent(day: self, type: "high", height: Day.getDouble(cursor, key: "high3_height")!, time: high3Time!))
        }
        
        self.sunrise = normaliseDate(sunrise)
        self.sunset = normaliseDate(sunset)
    }
    
    // Change the input date (which contains only 'time') to have the day/month/year of this Day
    func normaliseDate(testDate: NSDate) -> NSDate {
        let timeCal = NSCalendar.currentCalendar()
        let timeComponents = timeCal.components([.Hour,  .Minute, .Second], fromDate: testDate)
        timeComponents.day = getDateInfo(self.date, type: "day")
        timeComponents.month = getDateInfo(self.date, type: "month")
        timeComponents.year = getDateInfo(self.date, type: "year")
        return timeCal.dateFromComponents(timeComponents)!
    }
    
    // Return true if this Day is today
    func isToday() -> Bool {
        let dateComponents = calendar.components([.Day, .Month, .Year], fromDate: self.date)
        let todayComponents = calendar.components([.Day, .Month, .Year], fromDate:  NSDate())
        return todayComponents.year == dateComponents.year && todayComponents.month == dateComponents.month && todayComponents.day == dateComponents.day
    }
    
    // Return true if this Day is tomorrow
    func isTomorrow() -> Bool {
        let dateComponents = calendar.components([.Day, .Month, .Year], fromDate: self.date)
        let todayComponents = calendar.components([.Day, .Month, .Year], fromDate:  NSDate().dateByAddingTimeInterval(24*60*60))
        return todayComponents.year == dateComponents.year && todayComponents.month == dateComponents.month && todayComponents.day == dateComponents.day
    }
    
    // Return a component (day/weekday/month/year) of input testDate
    func getDateInfo(testDate: NSDate, type: String) -> Int {
        switch type {
            case "day": return calendar.components(.Day, fromDate: testDate).day
            case "weekday": return calendar.components(.Weekday, fromDate: testDate).weekday
            case "month": return calendar.components(.Month, fromDate: testDate).month
            case "year": return calendar.components(.Year, fromDate: testDate).year
            default: break
        }
        return -1
    }
    
    // Return a string representing month (Jan/Feb/etc.) or day (Mon/Tues/etc.) of input testDate
    func getDateInfoString(testDate: NSDate, type: String) -> String {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        switch type {
            case "month":
                let months = dateFormatter.shortMonthSymbols
                return months[getDateInfo(testDate, type: "month") - 1]
            case "day":
                let days = dateFormatter.weekdaySymbols
                return days[getDateInfo(testDate, type: "weekday") - 1]
            default: break
        }
        return ""
    }
    
    // Return canonical string of day name of inputString (i.e. today/tomorrow/Mon/Tues/etc.)
    func getDayName(testDate: NSDate) -> String{
        if isToday(){
            return "Today"
        }
        if isTomorrow(){
            return "Tomorrow"
        }
        return getDateInfoString(testDate, type: "day")
    }

    // Get a date from a column in an input DB row cursor
    private class func getDate(timeParseFormatter: NSDateFormatter, cursor: Row, key: String) -> NSDate? {
        let dateExp = Expression<String>(key)
        let dateStr = cursor[dateExp].stringByReplacingOccurrencesOfString(" BST", withString: "")
        return timeParseFormatter.dateFromString(dateStr)
    }
    
    // get a double from a column in an input DB row cursor
    private class func getDouble(cursor: Row, key: String) -> Double? {
        let doubleExp = Expression<String>(key)
        let doubleStr = cursor[doubleExp].stringByReplacingOccurrencesOfString("m", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return Double(doubleStr)!
    }
}