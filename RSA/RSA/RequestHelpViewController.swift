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
    }
    
    @IBAction func submitRequestForHelpButtonTapped(sender: UIButton) {
        
        //        EventController.sharedInstance.createEvent(helpSummaryTextView.text, eventLongtitude: 0, eventLatitude: 0, eventCreationDate: NSDate()) {
        //
        //            print("event created")
        
        UserController.sharedInstance.fetchUserRecords("User") { (records) in
            let submitEventAlertController = UIAlertController(title: "Ask for help?", message: "Press Ok to request help from \(records.count) user in your area.", preferredStyle: .Alert)
            submitEventAlertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) in
                EventController.sharedInstance.createEvent(self.helpSummaryTextView.text, eventLongtitude: 0, eventLatitude: 0, eventCreationDate: NSDate()) {
                    
                    print("event created")
                }
                
            }))
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
