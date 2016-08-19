//
//  AboutViewController.swift
//  GowerTidesiOS
//
//  Created by Will Webberley on 19/08/2016.
//  Copyright © 2016 Will Webberley. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func twitterClicked(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.twitter.com/flyingSparx")!)
    }
    @IBAction func emailClicked(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "mailto:will@flyingsparx.net")!)
    }
    @IBAction func sourceClicked(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/flyingsparx/GowerTidesiOS")!)
    }
    @IBAction func licenceClicked(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.gnu.org/licenses/gpl-3.0.en.html")!)
    }
}
