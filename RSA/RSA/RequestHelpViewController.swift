//
//  RequestHelpViewController.swift
//  RSA
//
//  Created by Karl Pfister on 7/13/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import UIKit
import CloudKit

class RequestHelpViewController: UIViewController {
    
    var events: [Event] = []
    var users: [User] = []
    
    
    // I need to fetch all the records of type user and set it to my users array.
    
    //MARK: Outlets
    
    @IBOutlet weak var sumbitRequestForHelp: UIButton!
    
    @IBOutlet weak var helpSummaryTextView: UITextView!
    
    @IBOutlet weak var nineOneOneButton: UIButton!
    
    //MARK: Actions
    
    @IBAction func nineOneOneButtonTapped(sender: AnyObject) {
        let emergencyAlert = UIAlertController(title: "911", message: "Are you sure you want to call 911?", preferredStyle: .Alert)
        let dissmissAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let call911Action = UIAlertAction(title: "Call 911", style: .Default) { (action) in
            if let url = NSURL(string: "tel://911") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        emergencyAlert.addAction(dissmissAction)
        emergencyAlert.addAction(call911Action)
        self.presentViewController(emergencyAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func submitRequestForHelpButtonTapped(sender: UIButton) {
        
        UserController.sharedInstance.fetchUserRecords("User") { (records) in
            let submitEventAlertController = UIAlertController(title: "Ask for help?", message: "Press Ok to request help from \(records.count) users in your area.", preferredStyle: .Alert)
            let dissmissAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let submitRequestAction = UIAlertAction(title: "Send", style: .Default, handler: { (action) in
                EventController.sharedInstance.createEvent(self.helpSummaryTextView.text, eventLongtitude: 0, eventLatitude: 0, eventCreationDate: NSDate()) {
                    
                    print("event created - yeahhhhh right. I'll believe it when i see it.")
                }
            })
            submitEventAlertController.addAction(submitRequestAction)
            submitEventAlertController.addAction(dissmissAction)
            self.presentViewController(submitEventAlertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
