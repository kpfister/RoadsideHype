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
    var cloudKitManager = CloudKitManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Push Notifications
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        cloudKitManager.fetchSubscription("allEvents") { (subscription, error) in
            print(subscription)
        }
        
        
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
        
        guard let remoteNotificationDictionary = userInfo as? [String: NSObject] else { return }
        let cloudKitNotification = CKQueryNotification(fromRemoteNotificationDictionary: remoteNotificationDictionary)
        guard let recordID = cloudKitNotification.recordID else { return }
        
        let eventController = EventController.sharedInstance
        eventController.retrieveEventForRecordID(recordID) { (event) in
            // do whatever with this event
            
            dispatch_async(dispatch_get_main_queue()) {
                
                // show table view
                
                let eventAlert = UILocalNotification()
                
                eventAlert.alertTitle = "Place holder for title"
                eventAlert.alertBody = "Place for body" // This is the local. This is what the user will see.
                
                application.presentLocalNotificationNow(eventAlert)
                
                print("Alert has been sent... maybe... prolly not." )
                
                // TODO: alert to show users that there was an event.
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                guard let destinationViewController = storyboard.instantiateViewControllerWithIdentifier("EventNotifVC") as? EventNotificationTableViewController else { return }
                destinationViewController.modalPresentationStyle = .FullScreen
                destinationViewController.event = event
                
                if let rootVC = self.window?.rootViewController {
                    rootVC.presentViewController(destinationViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
}


