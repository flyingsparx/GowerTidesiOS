//
//  PageItemController.swift
//  GowerTidesiOS
//
//  Created by Will Webberley.
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit
import SwiftCharts

class PageItemController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var untilSunsetLabel: UILabel!
    @IBOutlet weak var graphView: UIView!
    
    // MARK: - Variables
    let dateFormatter = NSDateFormatter()
    var itemIndex: Int = 0
    var day: Day? = nil
    var chart: LineChart? = nil
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI(){
        let today = NSDate()
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
            print(today)
            print(day!.sunset)
            if today.earlierDate(day!.sunset).isEqualToDate(day!.sunset){ // If sunset in past
                untilSunsetLabel.text = "Sun has set"
            }
            else{
                let hours = NSCalendar.currentCalendar().components(.Hour, fromDate: NSDate(), toDate: day!.sunset, options: []).hour
                let mins = NSCalendar.currentCalendar().components(.Minute, fromDate: NSDate(), toDate: day!.sunset, options: []).minute % 60
                var minString = String(mins)
                if mins < 10{
                    minString = "0" + String(mins)
                }
                untilSunsetLabel.text = String(hours) + ":" + minString + " 'til sunset"
            }
        }
        else{
            untilSunsetLabel.hidden = true
        }
        
        let chartConfig = ChartConfigXY(
            xAxisConfig: ChartAxisConfig(from: 0, to: 24, by: 4),
            yAxisConfig: ChartAxisConfig(from: 0, to: 15, by: 5)
        )
        
        
        chart = LineChart(
            frame: CGRectMake(0.0, 0.0, CGRectGetWidth(graphView.frame), CGRectGetHeight(graphView.frame)),
            chartConfig: chartConfig,
            xTitle: "Time (24 H)",
            yTitle: "Tide height (m)",
            lines: [
                (chartPoints: [(2.0, 2.6), (4.2, 4.1), (7.3, 1.0), (8.1, 11.5), (14.0, 3.0)], color: UIColor.blueColor())
            ]
        )
        
        graphView.addSubview(chart!.view)
        
    }
    
    func setInfo(day: Day){
        self.day = day
    }
    
}
