//
//  UserTableViewController.swift
//  RSA
//
//  Created by Karl Pfister on 7/13/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    //MARK: Outlets
    
    var user: User?
    var image: UIImage?
    
    @IBOutlet weak var userAboutMeTextView: UITextView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    @IBOutlet weak var setPrimaryLocationButton: UIButton!
    //MARK: Actions

    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        
        if let userImage = image, username = usernameTextField.text where username.characters.count > 0, let userAboutMe = userAboutMeTextView.text where userAboutMe.characters.count > 0, let phoneNumber = phoneNumberTextField.text where phoneNumber.characters.count > 0 {
            if let user = user {
                // Update existing user
                UserController.sharedInstance.updateUser(user)
            } else {
                //TODO: Come back and fix the defualt values for locations.
                UserController.sharedInstance.createUser(username, userAboutMe: userAboutMe, phoneNumber: phoneNumber, rangeToTravel: 0.0, latitude: 0.0, longtitude: 0.0, image: userImage)
                print("User created")
                // Create new user
            }
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            // TODO: Bring up alert controller asking the user to make sure they filled out all of the fields
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        // This is fixing a bug with my text view.
        userAboutMeTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func setPrimaryLocationButtonTapped(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = UserController.sharedInstance.currentUser {
            self.user = user
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    
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
