//
//  PageItemController.swift
//  GowerTidesiOS
//
//  Created by Will Webberley.
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit

class PageItemController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var untilSunsetLabel: UILabel!
    
    // MARK: - Variables
    let dateFormatter = NSDateFormatter()
    var itemIndex: Int = 0
    var day: Day? = nil
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI(){
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = NSLocale(localeIdentifier: "en_GB_POSIX")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB_POSIX")
        
        dayLabel.text = day!.getDayName(day!.date)
        dateLabel.text = dateFormatter.stringFromDate(day!.date)
        sunriseLabel.text = timeFormatter.stringFromDate(day!.sunrise)
        sunsetLabel.text = timeFormatter.stringFromDate(day!.sunset)
        
        if day!.isToday(){
            if NSDate().compare(day!.sunrise) == NSComparisonResult.OrderedDescending{
                untilSunsetLabel.text = "Sun has set"
            }
            else{
                let hours = NSCalendar.currentCalendar().components(.Hour, fromDate: NSDate(), toDate: day!.sunset, options: []).hour
                let mins = NSCalendar.currentCalendar().components(.Minute, fromDate: NSDate(), toDate: day!.sunset, options: []).minute % 60
                var minString = String(mins)
                if mins < 10{
                    minString = "0" + String(mins)
                }
                print("Sunset in " + String(hours) + ":" + minString)
                untilSunsetLabel.text = "Sunset in " + String(hours) + ":" + minString
            }
        }
        else{
            untilSunsetLabel.hidden = true
        }
    }
    
    func setInfo(day: Day){
        self.day = day
    }
    
}
