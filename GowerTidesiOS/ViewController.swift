//
//  ViewController.swift
//  GowerTidesiOS
//
//  Created by Will Webberley
//  Copyright (c) 2014 swiftiostutorials.com. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController, UIPageViewControllerDataSource {
    
    // MARK: - Variables
    private var pageViewController: UIPageViewController?
    var db:Connection? = nil
    let dateFormatter = NSDateFormatter()
    var days: [Day] = []

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB_POSIX")
        
        loadDB()
        
        let singleDay:NSTimeInterval = 24*60*60 //one day
        let today = NSDate()
        let dateFrom = today.dateByAddingTimeInterval(-24*60*60*14) //14 days ago
        let dateTo = today.dateByAddingTimeInterval(24*60*60*14) //14 Days later
        var currentDate = dateFrom
        
        while currentDate.compare(dateTo) == NSComparisonResult.OrderedAscending
        {
            let day:Day? = getData(currentDate)
            days.append(day!);
            currentDate = currentDate.dateByAddingTimeInterval(singleDay)
        }
        
        pageViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as? UIPageViewController
        pageViewController!.dataSource = self
        pageViewController!.setViewControllers([getItemController(14)!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        print("here");
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    func getData(date: NSDate) -> Day? {
        do{
            let year = Expression<Int>("year")
            let month = Expression<Int>("month")
            let day = Expression<Int>("day")
            
            let users = Table("data")
            
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            
            let query = users
                .filter(year==components.year)
                .filter(month==components.month)
                .filter(day==components.day)
                .limit(1)
            
            for user in try db!.prepare(query){
                return Day(date: date, cursor: user)
            }
        }
        catch {
            print("error querying")
        }
        return nil
    }
    
    func loadDB(){
        do {
            let filemgr = NSFileManager.defaultManager()
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let docsDir = dirPaths[0]
            let databasePath = docsDir + "/tides"
            
            //if not there, copy from bundle
            if !filemgr.fileExistsAtPath(databasePath) {
                let bundleDatabasePath = NSBundle.mainBundle().pathForResource("tides", ofType: "")
                try filemgr.copyItemAtPath(bundleDatabasePath!, toPath: databasePath)
            }
            db = try Connection(databasePath as String)
            
        }
        catch {
            print("error")
        }
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController

        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex+1 < days.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> PageItemController? {
        
        if itemIndex < days.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as! PageItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.setInfo(days[itemIndex])
            return pageItemController
        }
        
        return nil
    }

}

