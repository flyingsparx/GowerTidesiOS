//
//  TideEntryView.swift
//  GowerTidesiOS
//
//  Created by Will Webberley on 20/08/2016.
//  Copyright © 2016 Will Webberley. All rights reserved.
//

import UIKit

class TideEntryView: UIView {

    let tideEvent: TideEvent
    
    init(event: TideEvent, index: Int) {
        self.tideEvent = event
        super.init(frame: CGRect(x: 85 * index, y: 15, width: 80, height: 45))
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = NSLocale(localeIdentifier: "en_GB_POSIX")
        
        layer.cornerRadius = 10.0
        backgroundColor = UIColor.whiteColor()
        
        let tideType = UILabel(frame: CGRect(x: 30, y: 6, width: 75, height: 17))
        tideType.text = event.type.uppercaseString
        tideType.textColor = UIColor.grayColor()
        tideType.font = tideType.font.fontWithSize(14)
        
        let icon = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 17))
        icon.image = UIImage(named: tideEvent.type)
        
        let tideTime = UILabel(frame: CGRect(x: 5, y: 25, width:35, height:10))
        tideTime.text = timeFormatter.stringFromDate(event.time)
        tideTime.font = tideTime.font.fontWithSize(12)
        
        let timeUntil = UILabel(frame:CGRect(x: 40, y: 25, width: 40, height: 10))
        timeUntil.font = tideTime.font.fontWithSize(12)
        if event.day.isToday(){
            let now = NSDate()
            timeUntil.textColor = UIColor.greenColor()
            var labelSign = "+"
            var untilComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: now, toDate: event.time, options: [])
            
            if now.earlierDate(event.time).isEqualToDate(event.time){
                labelSign = "-"
                timeUntil.textColor = UIColor.redColor()
                untilComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: event.time, toDate: now, options: [])
            }
            let mins = untilComponents.minute
            var minString = String(mins)
            if mins < 10{
                minString = "0" + String(mins)
            }
            timeUntil.text = labelSign + String(untilComponents.hour) + ":" + minString
        }
        else{
            timeUntil.hidden = true
        }
        
        addSubview(icon)
        addSubview(tideType)
        addSubview(tideTime)
        addSubview(timeUntil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
