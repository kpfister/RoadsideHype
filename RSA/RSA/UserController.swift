//
//  UserController.swift
//  RSA
//
//  Created by Karl Pfister on 7/14/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import Foundation

class UserController {
    
    let cloudKitManager: CloudKitManager
    
    var isSynching: Bool = false
    
    
    init() {
        
        self.cloudKitManager = CloudKitManager()
        
        subscribeToNewEvents { (success, error) in
            if success {
                print("Succesfully subscribed to new events.")
            }
        }
        
    }
    // Youre CRUD Methods go here.
    
    func createUser(username: String, userImage: String, userAboutMe: String, phoneNumber: String, rangeToTravel: Float, latitude: Float, longtitude: Float) {
        
        // Create user
        // Save context(This will save it to core data)
        // NeXT Step add user to CloudKit
        // Use user.cloudKitRecord to save that record to CloudKit by calling cloudKitManager.saveRecord()
        // Call user.update(record) to add the recordID to the user
    }
    
    
    func updateUser(user: User) {
        // An updated user should be passed into this method
        
        // Update user in core data TODO: Get back to Nathan on how this should be implemented
        
        // With the user, call cloudKitManager.modifyRecords() // (This will update our user in CloudKit)
    }
    
    func deleteUser(user: User) {
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
    
    /* TODO: Talk to Alan about whether or not these are needed
     func synchedRecords() {
     
     }
     
     func unsyncedRecords() {
     
     }
     
     //MARK: - Sync
     func performFullSync() {
     
     }
     
     func fetchRecords() {
     
     }
     
     func pushChangedToCloudKit() {
     
     }
     */
    
    //MARK: Subscriptions
    
    func subscribeToNewEvents(completion: ((success: Bool, error: NSError?)->Void)?) {
        let predicate = NSPredicate(value: true)
        
//        cloudKitManager.subscribe(<#T##type: String##String#>, predicate: <#T##NSPredicate#>, subscriptionID: <#T##String#>, contentAvailable: <#T##Bool#>, options: <#T##CKSubscriptionOptions#>, completion: <#T##((subscription: CKSubscription?, error: NSError?) -> Void)?##((subscription: CKSubscription?, error: NSError?) -> Void)?##(subscription: CKSubscription?, error: NSError?) -> Void#>)
        
    }
    
    
    
    
    
}//END Of Class
