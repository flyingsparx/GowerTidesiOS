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
    
    let date, sunrise, sunset: NSDate
    
    init(date: NSDate, cursor: Row){
        let timeParseFormatter = NSDateFormatter()
        timeParseFormatter.dateFormat = "h:m a"
        timeParseFormatter.locale = NSLocale(localeIdentifier: "en_GB_POSIX")
        
        self.date = date
        self.sunrise = Day.getDate(timeParseFormatter, cursor: cursor, key: "sunrise")
        self.sunset = Day.getDate(timeParseFormatter, cursor: cursor, key: "sunset")
        
    }
    
    private class func getDate(timeParseFormatter: NSDateFormatter, cursor: Row, key: String) -> NSDate{
        let sunriseExp = Expression<String>(key)
        let sunriseStr = cursor[sunriseExp].stringByReplacingOccurrencesOfString(" BST", withString: "")
        return timeParseFormatter.dateFromString(sunriseStr)!
    }
    
}