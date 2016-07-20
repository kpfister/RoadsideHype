//
//  User.swift
//  RSA
//
//  Created by Karl Pfister on 7/14/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData
import CloudKit
import UIKit

class User: SyncableObject, CloudKitManagedObject {
    
    
    
    convenience init(photo: NSData, username: String, phoneNumber: String, longtitude: NSNumber, rangeToTravel: NSNumber, userAboutMe: String, userImage: String, latitude: NSNumber, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context) else {
            fatalError()
        }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.username = username
        self.phoneNumber = phoneNumber
        self.longtitude = longtitude
        self.latitude = latitude
        self.rangeToTravel = rangeToTravel
        self.userImage = userImage
        self.photoData = photo
        self.recordName = self.nameForManagedObject()
        //MARK: TODO change name for manage obj
    }
    
    var photo: UIImage? {
        
        guard let photoData = self.photoData else { return nil }
        
        return UIImage(data: photoData)
    }
    
    lazy var temporaryPhotoURL: NSURL = {
        
        // Must write to temporary directory to be able to pass image file path url to CKAsset
        
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = NSURL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.URLByAppendingPathComponent(self.recordName).URLByAppendingPathExtension("jpg")
        
        self.photoData?.writeToURL(fileURL, atomically: true)
        
        return fileURL
    }()
    
    //MARK: CloudkitManagedObject Methods
    var recordType: String = "User"
    
    var cloudKitRecord: CKRecord? {
        let recordID = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        record["timestamp"] = timestamp
        record["username"] = username
        record["phoneNumber"] = phoneNumber
        record["longtitude"] = longtitude
        record["latitude"] = latitude
        record["rangeToTravel"] = rangeToTravel
        record["userImage"] = userImage
        record["photoData"] = photoData
        
        
        return record
    }
    
    convenience required init?(record: CKRecord, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let timestamp = record.creationDate,
            let photoData = record["photoData"] as? CKAsset else {
                return nil
        }
        guard let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context) else {
            fatalError("Error! CoreData failed to create an entity from entity description/ \(#function)")
        }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.timestamp = timestamp
        self.recordIDData = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
        self.recordName = record.recordID.recordName
        self.photoData = NSData(contentsOfURL: photoData.fileURL)
        
    }
    
} //End of Class
