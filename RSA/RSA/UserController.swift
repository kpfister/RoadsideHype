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
    
    var currentUser: User?
    
    static let sharedInstance = UserController()
    
    init() {
        
        self.cloudKitManager = CloudKitManager()
        
        subscribeToNewEvents { (success, error) in
            if success {
                print("Succesfully subscribed to new events.")
            }
        }
        
        // Grab current user from cloudkit
        cloudKitManager.fetchLoggedInUserRecord { (record, error) in
            guard let record = record else {
                return
            }
            self.currentUser = User(record: record)
        }
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
    
    
    func updateUser(user: User) {
        // An updated user should be passed into this method
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
    
    
    //MARK: Subscriptions
    
    func subscribeToNewEvents(completion: ((success: Bool, error: NSError?)->Void)?) {
        let predicate = NSPredicate(value: true)
        
        cloudKitManager.subscribe("User", predicate: predicate, subscriptionID: "allEvents", contentAvailable: true, options: .FiresOnRecordCreation) { (subscription, error) in
            if let completion = completion {
                let success = subscription != nil
                completion(success: success, error: error)
            }
        }
    }
    
    
    
    
    
}//END Of Class
