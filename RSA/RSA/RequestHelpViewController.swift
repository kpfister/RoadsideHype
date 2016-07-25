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
    
    //MARK: Outlets
    
    @IBOutlet weak var sumbitRequestForHelp: UIButton!
    
    @IBOutlet weak var helpSummaryTextView: UITextView!

    @IBOutlet weak var nineOneOneButton: UIButton!
    
    //MARK: Actions 
    
    @IBAction func nineOneOneButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func submitRequestForHelpButtonTapped(sender: UIButton) {
        
        EventController.sharedInstance.createEvent(helpSummaryTextView.text, eventLongtitude: 0, eventLatitude: 0, eventCreationDate: NSDate()) { 
        
            print("event created")
        }
        
//        let helpSummary = helpSummaryTextView.text
        
        // Okay, when someone presses request help I want my app to send a push notification to all users. That push notification should show the EventNotificationView. The fields in that view should display all the users information that sent the request.
        
        let database = CKContainer.defaultContainer().publicCloudDatabase
        database.fetchAllSubscriptionsWithCompletionHandler { (subscriptions, error) in
            if error == nil {
                if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                        database.deleteSubscriptionWithID(subscription.subscriptionID, completionHandler: { (str, error) in
                            if error != nil {
                                //TODO add an alert telling the user there was a issue.
                                print(error!.localizedDescription)
                            }
                        })
                    }
                    for event in self.events {
                        let predicate = NSPredicate(format: "Event = %@", event)
                        let subscription = CKSubscription(recordType: "Event", predicate: predicate, options: .FiresOnRecordCreation)
                        
                        let notificiation = CKNotificationInfo()
                        notificiation.alertBody = "Help! A user needs your help!"
                        notificiation.soundName = UILocalNotificationDefaultSoundName
                        
                        subscription.notificationInfo = notificiation
                        
                        database.saveSubscription(subscription, completionHandler: { (result, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                        })
                    }
                }
            }
            else {
                // more error handling
                print(error!.localizedDescription)
            }
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
