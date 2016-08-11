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
        
        var maxHeight = 0.0;
        var coordinates = [(Double, Double)]();
        let lastTideYesterday = day!.yesterday!.tideEvents[(day!.yesterday?.tideEvents.endIndex)! - 1];
        let firstTideTomorrow = day!.tomorrow!.tideEvents[0];
        coordinates.append((0 - (24 - lastTideYesterday.getMinutes()), lastTideYesterday.height))
        for event in day!.tideEvents {
            coordinates.append((event.getMinutes(), event.height))
        }
        coordinates.append((24 + firstTideTomorrow.getMinutes(), firstTideTomorrow.height))
        for coord in coordinates {
            
            if (coord.1 > maxHeight){
                maxHeight = coord.1 + 3
            }
        }
        let chartConfig = ChartConfigXY(
            xAxisConfig: ChartAxisConfig(from: 0, to: 24, by: 4),
            yAxisConfig: ChartAxisConfig(from: 0, to: maxHeight, by: 2)
        )
        chart = LineChart(
            frame: CGRectMake(0.0, 0.0, CGRectGetWidth(graphView.frame), CGRectGetHeight(graphView.frame)),
            chartConfig: chartConfig,
            xTitle: "Time (24 H)",
            yTitle: "Tide height (m)",
            lines: [
                (chartPoints: coordinates, color: UIColor.blueColor())
            ]
        )
        
        graphView.addSubview(chart!.view)
        
    }
    
    func setInfo(day: Day){
        self.day = day
    }
    
}
