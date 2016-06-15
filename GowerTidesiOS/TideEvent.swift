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
    
    init(day: Day, type: NSString, height: Double, time: NSDate){
        self.day = day
        self.type = type
        self.height = height
        self.time = time
    }
}
