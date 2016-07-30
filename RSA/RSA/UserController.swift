//
//  UserController.swift
//  RSA
//
//  Created by Karl Pfister on 7/14/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import Foundation
import CloudKit
import UIKit
import CoreData

class UserController {
    
    let cloudKitManager: CloudKitManager
    
    var isSynching: Bool = false
    
    
    
    var currentUser: User? {
        let fetchRequest = NSFetchRequest(entityName: "User")
        let results = (try? Stack.sharedStack.managedObjectContext.executeFetchRequest(fetchRequest)) as? [User] ?? []
        return results.first ?? nil
        
    }
    
    static let sharedInstance = UserController()
    
    init() {
        
        self.cloudKitManager = CloudKitManager()
        
    }
    
    
    // Youre CRUD Methods go here.
    
    func createUser(username: String, userAboutMe: String, phoneNumber: String, rangeToTravel: Float, latitude: Float, longtitude: Float, image: UIImage) {
        // Create NSdata from image
        guard let data = UIImageJPEGRepresentation(image, 0.8)
            else {return}
        
        // Create user
        let user = User(photo: data, username: username, phoneNumber: phoneNumber, longtitude: longtitude, rangeToTravel: rangeToTravel, userAboutMe: userAboutMe, latitude: latitude)
        
        // Save context(This will save it to core data)
        saveContext()
        
        // NeXT Step add user to CloudKit
        if let userCloudKitRecord = user.cloudKitRecord {
            
            // Use user.cloudKitRecord to save that record to CloudKit by calling cloudKitManager.saveRecord()
            cloudKitManager.saveRecord(userCloudKitRecord, completion: { (record, error) in
                if let record = record {
                    
                    // Call user.update(record) to add the recordID to the user
                    user.update(record)
                }
            })
        }
    }
    
    
    func updateUser(user: User, username: String, phone: String, aboutMe: String, image: NSData) {
        // An updated user should be passed into this method
        
        user.username = username
        user.phoneNumber = phone
        user.userAboutMe = aboutMe
        user.photoData = image
        
        saveContext()
        
        
        // Update user in core data TODO: Get back to Nathan on how this should be implemented
        
        // With the user, call cloudKitManager.modifyRecords() // (This will update our user in CloudKit)
        guard let cloudKitRecord = user.cloudKitRecord else { return }
        cloudKitManager.modifyRecords([cloudKitRecord], perRecordCompletion: nil, completion: nil)
    }
    
    func deleteUser(user: User) {
        
        if let moc = user.managedObjectContext {
            moc.deleteObject(user)
            saveContext()
        }
        
        guard let cloudKitRecord = user.cloudKitRecord else {
            return
        }
        cloudKitManager.deleteRecordWithID(cloudKitRecord.recordID) { (recordID, error) in
            
        }
        
        // Remove user from managed object context
        // Once the user is removed from the MOC, save MOC
        // Then call cloudKitManager.deleteRecordWithID()
    }
    
    func saveContext() {
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Unable to save context: \(error)")
        }
        
    }
    
    //MARK: - Helper Fetches
    
    func userWithName(userRecordID: CKRecordID, completion: ((user: User?) -> Void)?) {
        
        cloudKitManager.fetchRecordWithID(userRecordID) { (record, error) in
            if let record = record,
                let user = User(record: record) {
                
                if let  completion = completion {
                    completion(user: user)
                }
            } else {
                if let completion = completion {
                    completion(user: nil)
                }
            }
        }
    }
    
    
    func fetchRecords(type: String, completion: (()-> Void)?) {
        var predicate = NSPredicate(format: "NOT(recordID IN %@)")
        predicate = NSPredicate(value: true)
        
        cloudKitManager.fetchRecordsWithType(type, predicate: predicate, recordFetchedBlock: { (record) in
            let _ = User(record: record)
            self.saveContext()
        }) { (records, error) in
            if error != nil {
                print("Error! unable to fetch user records")
            }
            if let completion = completion{
                completion()
            }
        }
    }
    
    func pushChangedToCloudKit(user: User, completion: ((success: Bool, error: NSError?)->Void)?) {
        guard let userRecord = user.cloudKitRecord else { return }
        cloudKitManager.saveRecords([userRecord], perRecordCompletion: nil, completion: nil)
        
    }
    
    func fetchUserRecords(type: String, completion: ((records:[CKRecord]) -> Void)?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let predicate = NSPredicate(value: true)
        UserController.sharedInstance.cloudKitManager.fetchRecordsWithType(type, predicate: predicate, recordFetchedBlock: { (record) in
            
        }) { (records, error) in
            if error != nil {
                print("Error! Unable to fetch User records")
            }
            if let completion = completion, records = records {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(records: records) // christen  and i added this to the main que.\\
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                })
            }
        }
    }
    
    
    
}//END Of Class
