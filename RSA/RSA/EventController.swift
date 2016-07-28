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
    
    var currentHelpRequestID: CKRecordID?
    
    // create a func to save a record id. that will take in the recordID from the notification and
    
    static let sharedInstance = EventController()
    
    init() {
        self.cloudKitManager = CloudKitManager()
        
        //        subscribeToNewEvents { (success, error) in
        //            if success {
        //                print("Succesfully subscribed to new events.")
        //            }
        //        }
        
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
    
    func retrieveEventForRecordID(recordID: CKRecordID, completion: (Event) -> Void) {
        cloudKitManager.fetchRecordWithID(recordID) { (record, error) in
            if let error = error {
                NSLog("Error fetching event for record ID \(recordID): \(error)")
                return
            }
            
            guard let record = record else { return }
            
            if let event = Event(record: record) {
                completion(event)
            }
        }
    }
    
    //
    //    func retreiveRequestForHelpEvent(completion: (event: Event?) -> Void) {
    //        // check for current event id
    //
    //        guard let currentHelpRequestID = currentHelpRequestID else { completion(event: nil); return }
    //        // loads the event with the id from cloud kit
    //        let record = CKRecord(recordType: "User") // TODO: Actually get record from CloudKit (look at Timeline)
    //        let event = Event(record: record)
    //        completion(event: event)
    //        // call completion passing in the event
    //        // EventNotificationTVC will have this method in the Veiw did load
    //
    //    }
    
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
    
    func checkForSubscription() {
        //        cloudKitManager.unsubscribe("allPosts") { (subscriptionID, error) in
        //
        //        }
        //        cloudKitManager.fetchSubscription("allEvents") { (subscription, error) in
        //            print(subscription)
        //        }
        //        cloudKitManager.fetchSubscriptions { (subscriptions, error) in
        //
        //        }
        
    }
    
    //MARK: Subscriptions
    
    func subscribeToNewEvents(completion: ((success: Bool, error: NSError?)->Void)?) {
        let predicate = NSPredicate(value: true)
        
        
        cloudKitManager.subscribe("Event", predicate: predicate, subscriptionID: "allEvents", contentAvailable: true, alertBody: "", desiredKeys: ["phoneNumber"], options: .FiresOnRecordCreation) { (subscription, error) in
            if let completion = completion {
                let succcess = subscription != nil
                completion(success: succcess, error: error)
            }
        }
        //        cloudKitManager.subscribe2("Event", predicate: predicate, subscriptionID: "allEvents", alertBody: "Placeholder for event body", options: .FiresOnRecordCreation) { (subscription, error) in
        //            if let completion = completion {
        //                let success = subscription != nil
        //                completion(success: success, error: error)
        //                
        //            }
        //        }
    }
    
    
    
    
    
    
    
    
    
}// End of class