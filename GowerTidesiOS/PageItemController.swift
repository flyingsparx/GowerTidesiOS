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
    @IBOutlet var label: UILabel!

    // MARK: - Variables
    let dateFormatter = NSDateFormatter()
    var itemIndex: Int = 0
    var day: Day? = nil
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:m a"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_GB_POSIX")
        
        label.text = dateFormatter.stringFromDate(day!.sunrise)
    }
    
    func setInfo(day: Day){
        self.day = day
    }
    
}
