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
    
    
    static let sharedInstance = EventController()
    
    init() {
        self.cloudKitManager = CloudKitManager()
    }
    
    
    //MARK: - CRUD Methods.
    
    func createEvent(eventSummary: String, eventLongtitude: Float, eventLatitude: Float, eventCreationDate: NSDate, completion: (() -> Void)?) {
        
        guard let currentUser = UserController.sharedInstance.currentUser else { return }
        
        let event = Event(creator: currentUser, eventCreationDate: eventCreationDate, eventLatitude: eventLatitude, eventLongtitude: eventLongtitude, eventSummary: eventSummary)
        
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
        
        self.cloudKitManager.fetchRecordWithID(recordID) { (record, error) in
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
        //May not need this.
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
    }
}// End of class