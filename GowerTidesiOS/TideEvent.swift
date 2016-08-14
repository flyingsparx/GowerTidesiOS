//
//  TideEvent.swift
//  GowerTidesiOS
//
//  Created by Will Webberley on 15/06/2016.
//  Copyright © 2016 Will Webberley. All rights reserved.
//

import Foundation

class TideEvent{
    
    var day: Day
    var type: NSString
    var height: Double
    var time: NSDate
    let calendar = NSCalendar.currentCalendar()
    
    init(day: Day, type: NSString, height: Double, time: NSDate){
        self.day = day
        self.type = type
        self.height = height
        self.time = time
    }
    
    // Return number of hours (in double) of this tide event since midnight of this Day
    func getMinutes() -> Int {
        let hours = calendar.components(.Hour, fromDate: self.time).hour
        let minutes = calendar.components(.Minute, fromDate: self.time).minute
        return (hours * 60) + minutes;
    }
}
