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
    
    init(date: NSDate, cursor: Row){
        let timeParseFormatter = NSDateFormatter()
        timeParseFormatter.dateFormat = "h:m a"
        timeParseFormatter.locale = NSLocale(localeIdentifier: "en_GB_POSIX")
        
        self.date = date
        self.sunrise = Day.getDate(timeParseFormatter, cursor: cursor, key: "sunrise")
        self.sunset = Day.getDate(timeParseFormatter, cursor: cursor, key: "sunset")
        
        self.sunrise = normaliseDate(sunrise)
        self.sunset = normaliseDate(sunset)
    }
    
    func normaliseDate(testDate: NSDate) -> NSDate {
        let timeCal = NSCalendar.currentCalendar()
        let timeComponents = timeCal.components([.Hour,  .Minute, .Second], fromDate: testDate)
        timeComponents.day = getDateInfo(self.date, type: "day")
        timeComponents.month = getDateInfo(self.date, type: "month")
        timeComponents.year = getDateInfo(self.date, type: "year")
        return timeCal.dateFromComponents(timeComponents)!
    }
    
    func isToday() -> Bool {
        let dateComponents = calendar.components([.Day, .Month, .Year], fromDate: self.date)
        let todayComponents = calendar.components([.Day, .Month, .Year], fromDate:  NSDate())
        return todayComponents.year == dateComponents.year && todayComponents.month == dateComponents.month && todayComponents.day == dateComponents.day
    }
    
    func isTomorrow() -> Bool {
        let dateComponents = calendar.components([.Day, .Month, .Year], fromDate: self.date)
        let todayComponents = calendar.components([.Day, .Month, .Year], fromDate:  NSDate().dateByAddingTimeInterval(24*60*60))
        return todayComponents.year == dateComponents.year && todayComponents.month == dateComponents.month && todayComponents.day == dateComponents.day
    }
    
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
    
    func getDayName(testDate: NSDate) -> String{
        if isToday(){
            return "Today"
        }
        if isTomorrow(){
            return "Tomorrow"
        }
        return getDateInfoString(testDate, type: "day")
    }

    private class func getDate(timeParseFormatter: NSDateFormatter, cursor: Row, key: String) -> NSDate {
        let sunriseExp = Expression<String>(key)
        let sunriseStr = cursor[sunriseExp].stringByReplacingOccurrencesOfString(" BST", withString: "")
        return timeParseFormatter.dateFromString(sunriseStr)!
    }
    
}