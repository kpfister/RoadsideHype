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

    convenience init (eventCreationDate: NSDate, eventLatitude: Float, eventLongtitude: Float, eventSummary: String, context:NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context) else {
            fatalError("Unable to create event Entity")
        }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.eventCreationDate = eventCreationDate
        self.eventLatitude = eventLatitude
        self.eventLongtitude = eventLongtitude
        self.eventSummary = eventSummary
        self.recordName = self.nameForManagedObject()
    }
    
    var recordType: String = "Event"
    
    var cloudKitRecord: CKRecord? {
        let recordID = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        record["eventCreationDate"] = eventCreationDate
        record["eventLatitude"] = eventLatitude
        record["eventLongtitude"] = eventLongtitude
        record["eventSummary"] = eventSummary
        
        return record
    }
    
    convenience required init?(record: CKRecord, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let timestamp = record.creationDate else {
                print("Error creating record"); return nil
        }
        guard let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context) else {
            fatalError("Error! CoreData failed to create a record for Event")
        }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.timestamp = timestamp
        self.recordIDData = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
        self.recordName = record.recordID.recordName        
    }
    
}

