//
//  Event.swift
//  RSA
//
//  Created by Karl Pfister on 7/19/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//
//
import Foundation
import CoreData
import CloudKit
import UIKit


class Event: SyncableObject, CloudKitManagedObject  {

    convenience init (creator: User, eventCreationDate: NSDate = NSDate(), eventLatitude: Float, eventLongtitude: Float, eventSummary: String, context:NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context) else {
            fatalError("Unable to create event Entity")
        }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.eventCreationDate = eventCreationDate
        self.eventLatitude = eventLatitude
        self.eventLongtitude = eventLongtitude
        self.eventSummary = eventSummary
        self.recordName = self.nameForManagedObject()
        self.timestamp = eventCreationDate
        self.creator = creator
    }
    
    var recordType: String = "Event"
    
    var cloudKitRecord: CKRecord? {
        let recordID = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        record["eventCreationDate"] = eventCreationDate
        record["eventLatitude"] = eventLatitude
        record["eventLongtitude"] = eventLongtitude
        record["eventSummary"] = eventSummary
        
        //TOOD: Create a CKReference to the User.
        guard let user = creator, let userRecord = user.cloudKitRecord else { return nil }
        record["user"] = CKReference(record: userRecord, action: .DeleteSelf)
        
        return record
    }
    
    convenience required init?(record: CKRecord, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let timestamp = record.creationDate,
            
            let creator = record["user"] as? CKReference,
            
            let eventSummary = record["eventSummary"] as? String else {
                print("Error creating record"); return nil
        }
        guard let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context) else {
            fatalError("Error! CoreData failed to create a record for Event")
        }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.timestamp = timestamp
        self.recordIDData = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
        self.recordName = record.recordID.recordName
        self.eventSummary = eventSummary
        // Now to get my user with the event...
        
        // This is happening on the background thread and isn't getting called so the creator is never being set from the record
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            UserController.sharedInstance.userWithName(creator.recordID) { (user) in
                self.creator = user
            }
        })
    }
    
}

