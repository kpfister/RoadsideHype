//
//  EventController.swift
//  RSA
//
//  Created by Karl Pfister on 7/20/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CloudKit

class EventController {
    
    let cloudKitManager: CloudKitManager
    
    var isSynching: Bool = false
    
    var events = [Event]()
    
    
    static let sharedInstance = EventController()
    
    init() {
        self.cloudKitManager = CloudKitManager()
        
        subscribeToNewEvents { (success, error) in
            if success {
                print("Succesfully subscribed to new events.")
            }
        }
        
    }
    // Youre CRUD Methods go here.
    
    func createEvent(eventSummary: String, eventLongtitude: Float, eventLatitude: Float, eventCreationDate: NSDate, completion: (() -> Void)?) {
        
        let event = Event(eventCreationDate: eventCreationDate, eventLatitude: eventLatitude, eventLongtitude: eventLongtitude, eventSummary: eventSummary)
        
        saveContext()
        
        if let completion = completion {
            completion()
        }
        
        if let eventRecord = event.cloudKitRecord {
            cloudKitManager.saveRecord(eventRecord, completion: { (record, error) in
                if let record = record {
                    event.update(record)
                }
            })
        }
    }
    
    func sendPushNotificationFromEventCreation() {
        
        let database = CKContainer.defaultContainer().publicCloudDatabase
        database.fetchAllSubscriptionsWithCompletionHandler { (subscriptions, error) in
            if error == nil {
                if let subscriptions = subscriptions {
                    for subscription in subscriptions {
                        database.deleteSubscriptionWithID(subscription.subscriptionID, completionHandler: { (str, error) in
                            if error != nil {
                                //TODO add an alert telling the user there was a issue.
                                print("\(error!.localizedDescription) Error fetching all the subscriptions with ID")
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
                                print("\(error!.localizedDescription) Errorr saving subscription")
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
    
    // I dont think we want an update or a delete function as you cannnot update or delete the event.
    
    func saveContext() {
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Unable to save context: \(error)")
        }
        
    }
    
    //MARK: - Helper Fetches
    
   
    func fetchEventRecords(type: String, completion: (() -> Void)?) {
        var predicate = NSPredicate(format: "NOT(recordID IN %@)")
        predicate = NSPredicate(value: true)
        cloudKitManager.fetchRecordsWithType(type, predicate: predicate, recordFetchedBlock: { (record) in
            let _ = Event(record: record)
            self.saveContext()
            }) { (records, error) in
                if error != nil {
                    print("Error! Unable to fetch Event records")
                }
                if let completion = completion {
                    completion()
                }
        }
        
    }
    
    func pushChangedToCloudKit(event: Event, completion: ((success: Bool, error: NSError?) -> Void)?) {
        guard let eventRecord = event.cloudKitRecord else {return}
        cloudKitManager.saveRecords([eventRecord], perRecordCompletion: nil, completion: nil)
        
    }
    
    //MARK: Subscriptions
    
    func subscribeToNewEvents(completion: ((success: Bool, error: NSError?)->Void)?) {
        let predicate = NSPredicate(value: true)
        
        cloudKitManager.subscribe("Event", predicate: predicate, subscriptionID: "allPosts", contentAvailable: true, options: .FiresOnRecordCreation) { (subscribtion, error) in
            
            if let completion = completion {
                let success = subscribtion != nil
                completion(success: success, error: error)
            }
        }
    }
    
    
    
    
    
    
    
    
    
}// End of class