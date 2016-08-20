//
//  PageItemController.swift
//  GowerTidesiOS
//
//  Created by Will Webberley.
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit
import Charts

class PageItemController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var untilSunsetLabel: UILabel!
    @IBOutlet weak var graphView: LineChartView!
    @IBOutlet weak var tideTableView: UIView!
    
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
        
        
        
        let minsInDay = 60 * 24;
        var coordinates = [(Int, Double)]();
        if ((day!.yesterday) != nil){
            let lastTideYesterday = day!.yesterday!.tideEvents[(day!.yesterday?.tideEvents.endIndex)! - 1];
            coordinates.append((0 - (minsInDay - lastTideYesterday.getMinutes()), lastTideYesterday.height))
        }
        for event in day!.tideEvents {
            coordinates.append((event.getMinutes(), event.height))
        }
        if ((day!.tomorrow) != nil){
            let firstTideTomorrow = day!.tomorrow!.tideEvents[0];
            coordinates.append((minsInDay + firstTideTomorrow.getMinutes(), firstTideTomorrow.height))
        }
        
        var tide = 0;
        while tide < day!.tideEvents.count {
            tideTableView.addSubview(TideEntryView(event: day!.tideEvents[tide], index: tide))
            tide = tide + 1
        }
        
        var maxHeight = 0.0;
        for coord in coordinates {
            if (coord.1 > maxHeight){
                maxHeight = coord.1 + 3
            }
        }
        
        var chartDataSets = [LineChartDataSet]()
        var tideData = [ChartDataEntry]()
        var xValues = [String]()
        var x = 0
        while x < minsInDay {
            xValues.append(String(x/60) + ":00")
            x = x + 1
        }
        var y = 0
        while y < coordinates.count {
            tideData.append(ChartDataEntry(value: coordinates[y].1, xIndex: Int(coordinates[y].0)))
            y = y + 1
        }
        let tideDataSet = LineChartDataSet(yVals: tideData, label: "")
        tideDataSet.setColor(UIColor.blueColor())
        tideDataSet.drawFilledEnabled = true
        tideDataSet.circleRadius = 0
        tideDataSet.drawCubicEnabled = true
        tideDataSet.axisDependency = ChartYAxis.AxisDependency.Left
        tideDataSet.drawValuesEnabled = false
        chartDataSets.append(tideDataSet)
        
        if ((day?.isToday()) == true){
            var todayTimeData = [ChartDataEntry]()
            let calendar = NSCalendar.currentCalendar()
            let currentTime = NSDate()
            let hour = calendar.components(.Hour, fromDate: currentTime).hour
            let minutes = calendar.components(.Minute, fromDate: currentTime).minute
            let minsSinceMidnight = hour * 60 + minutes
            todayTimeData.append(ChartDataEntry(value: 0, xIndex: minsSinceMidnight))
            todayTimeData.append(ChartDataEntry(value: maxHeight, xIndex: minsSinceMidnight))
            
            let timeDataSet = LineChartDataSet(yVals: todayTimeData, label: "")
            timeDataSet.setColor(UIColor.redColor())
            timeDataSet.drawValuesEnabled = false
            timeDataSet.circleRadius = 0
            chartDataSets.append(timeDataSet)
        }
        
        var sunriseData = [ChartDataEntry]()
        sunriseData.append(ChartDataEntry(value: maxHeight, xIndex: 0))
        sunriseData.append(ChartDataEntry(value: maxHeight, xIndex: day!.getMinutes(day!.sunrise)))
        let sunriseDataSet = LineChartDataSet(yVals: sunriseData, label: "")
        sunriseDataSet.drawFilledEnabled = true
        sunriseDataSet.drawCirclesEnabled = false
        sunriseDataSet.drawValuesEnabled = false
        sunriseDataSet.lineWidth = 0
        sunriseDataSet.fillColor = UIColor.lightGrayColor()
        chartDataSets.append(sunriseDataSet)

        var sunsetData = [ChartDataEntry]()
        sunsetData.append(ChartDataEntry(value: maxHeight, xIndex: day!.getMinutes(day!.sunset)))
        sunsetData.append(ChartDataEntry(value: maxHeight, xIndex: minsInDay))
        let sunsetDataSet = LineChartDataSet(yVals: sunsetData, label: "")
        sunsetDataSet.drawFilledEnabled = true
        sunsetDataSet.drawCirclesEnabled = false
        sunsetDataSet.drawValuesEnabled = false
        sunsetDataSet.lineWidth = 0
        sunsetDataSet.fillColor = UIColor.lightGrayColor()
        chartDataSets.append(sunsetDataSet)
        
        let chartData = LineChartData(xVals: xValues, dataSets: chartDataSets)
        
        graphView.rightAxis.enabled = false
        graphView.leftAxis.drawLabelsEnabled = false
        graphView.leftAxis.drawGridLinesEnabled = false
        graphView.leftAxis.axisMinValue = 0
        graphView.leftAxis.axisMaxValue = maxHeight
        graphView.xAxis.setLabelsToSkip(4 * 60)
        
        graphView.leftAxis.axisLineColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        graphView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        
        graphView.xAxis.drawLabelsEnabled = true
        graphView.xAxis.labelPosition = .Bottom
        graphView.legend.enabled = false
        graphView.descriptionText = ""
        graphView.animate(yAxisDuration: 1, easingOption: .EaseOutQuad)
        
        graphView.xAxis.axisMinValue = 0
        graphView.xAxis.axisMaxValue = Double(minsInDay)
        
        graphView.data = chartData
    }
    
    func setInfo(day: Day){
        self.day = day
    }
    
}
