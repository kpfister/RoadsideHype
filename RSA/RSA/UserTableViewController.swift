//
//  UserTableViewController.swift
//  RSA
//
//  Created by Karl Pfister on 7/13/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import UIKit
import CloudKit

class UserTableViewController: UITableViewController {
    //MARK: Outlets
    
    var user: User?
    var image: UIImage?
    
    @IBOutlet weak var userImageView: UIView!
    
    @IBOutlet weak var userAboutMeTextView: UITextView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    @IBOutlet weak var setPrimaryLocationButton: UIButton!
    //TODO This will be called when i add in mapkit
    //MARK: Actions

    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        
        if let userImage = image, username = usernameTextField.text where username.characters.count > 0, let userAboutMe = userAboutMeTextView.text where userAboutMe.characters.count > 0, let phoneNumber = phoneNumberTextField.text where phoneNumber.characters.count > 0 {
            if let user = user {
                print("user is logged in")
                // Update existing user
                UserController.sharedInstance.updateUser(user)
            } else {
                //TODO: Come back and fix the defualt values for locations.
                UserController.sharedInstance.createUser(username, userAboutMe: userAboutMe, phoneNumber: phoneNumber, rangeToTravel: 0.0, latitude: 0.0, longtitude: 0.0, image: userImage)
                print("User created")
                // Create new user
                // Now that user is created I want to subscribe them to every Event. This will change for Version 2.
                UserController.sharedInstance.subscribeToNewEvents({ (success, error) in
                    print("Subscribed to new events")
                })
            }
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Oops!", message: "Looks like som important fields were left blank.", preferredStyle: .Alert)
            
            let dissmissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: { (_) in

            })
            alertController.addAction(dissmissAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        // This is fixing a bug with my text view.
        userAboutMeTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func setPrimaryLocationButtonTapped(sender: AnyObject) {
        //TODO: Add functionality to request and save the users perfered location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = UserController.sharedInstance.currentUser {
            self.user = user
            usernameTextField.text = user.username
            userAboutMeTextView.text = user.userAboutMe
            phoneNumberTextField.text = user.phoneNumber
            //TODO: Fix this. The view should see that a person already has a user and replace the fields.
        }
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPhotoSelector" {
            if let destinationVC = segue.destinationViewController as? PhotoSelecterViewController {
                destinationVC.delegate = self
            }
        }
    }
}

extension UserTableViewController: PhotoSelectViewControllerDelegate {
    func photoSelectViewControllerSelected(image: UIImage) {
        self.image = image
    }
}
