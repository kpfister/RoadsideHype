//
//  AppDelegate.swift
//  RSA
//
//  Created by Karl Pfister on 7/12/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Push Notifications
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        
        // Override point for customization after application launch.
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("\(deviceToken) They are registered")
        
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let eventAlert = UILocalNotification()
        
        eventAlert.alertTitle = "Place holder for title"
        eventAlert.alertBody = "Place for body"
        eventAlert.fireDate = NSDate()
        
        application.scheduleLocalNotification(eventAlert)
        print("Alert has been sent... maybe... prolly not." )
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
//        let destinationViewController = storyboard.instantiateViewControllerWithIdentifier("EventNotificationTableViewController") as! EventNotificationTableViewController
//        
//        let navigationController = self.window?.rootViewController as! UINavigationController
//        
//        navigationController.pushViewController(destinationViewController, animated: false, completion: nil)
        
}
    
}
        
//        let destinationViewController = storyboard.instantiateViewControllerWithIdentifier("EventNotificationTableViewController") as!EventNotificationTableViewController
//        
//        let navigationController = self.window?.rootViewController as! UINavigationController
//        navigationController.pushViewController(destinationViewController, animated: false)
//        
//        guard let notificationInfo = userInfo as? [String: NSObject] else { return }
//        
//        let queryNotification = CKQueryNotification(fromRemoteNotificationDictionary: notificationInfo)
//        
//        guard let recordID = queryNotification.recordID else { print ("No Record ID available from CKQueryNotification."); return }
//        
//        let cloudKitManager = CloudKitManager()
//        
//        cloudKitManager.fetchRecordWithID(recordID) { (record, error) in
//            
//                        guard let record = record else { print("Unable to fetch CKRecord from Record ID"); return }
//            
//            switch record.recordType {
//                
//                case "User":
//                let _ = User(record: record)
//                case "Event":
//                let _ = Event(record: record)
//            default:
//                return
//            }
//            EventController.sharedInstance.saveContext()
//        }
//        completionHandler(UIBackgroundFetchResult.NewData)
//        let view = EventNotificationTableViewController()
//        view.presentViewController(view, animated: true, completion: nil)
//    }}

/*
 func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
 
 println("didReceiveRemoteNotification")
 
 let storyboard = UIStoryboard(name: "Main", bundle: nil)
 
 let destinationViewController = storyboard.instantiateViewControllerWithIdentifier("MessageViewController") as MessageViewController
 
 let navigationController = self.window?.rootViewController as! UINavigationController
 
 navigationController?.pushViewController(destinationViewController, animated: false, completion: nil)
 
 }
 */

