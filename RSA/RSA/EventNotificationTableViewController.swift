//
//  EventNotificationTableViewController.swift
//  RSA
//
//  Created by Karl Pfister on 7/19/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import UIKit

class EventNotificationTableViewController: UITableViewController {
    
    var event: Event? {
        didSet {
            
            let _ = view
            
            updateViews()
        }
    }
    
    //MARK: Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var directionsToUser: UIButton!
    
    @IBOutlet weak var callUserButton: UIButton!
    
    @IBOutlet weak var userPhoneNumber: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var userEventSummaryTextView: UITextView!
    
    //MARK: Actions
    
    @IBAction func directionsToUserButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func callUserButtonTapped(sender: AnyObject) {
        let callUserAlert = UIAlertController(title: "Call User", message: "Are you sure you want to call this user?", preferredStyle: .Alert)
        let dismissCallUser = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let callUserAction = UIAlertAction(title: "Call", style: .Default) { (action) in
            if let userPhoneURL = NSURL(string:"tel://\(self.userPhoneNumber.text!)") {
                UIApplication.sharedApplication().openURL(userPhoneURL)
            }
        }
        callUserAlert.addAction(dismissCallUser)
        callUserAlert.addAction(callUserAction)
        presentViewController(callUserAlert, animated: true, completion: nil)
    }
    
    
    func updateViews() {
        guard let event = event,
        creator = event.creator else {
            // Update views to be blank?
            return
        }
        
        userEventSummaryTextView.text = event.eventSummary
        usernameLabel.text = creator.username
        userPhoneNumber.text = creator.phoneNumber
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        let view = UIView(frame: self.view.bounds)
        let blurEffect = UIBlurEffect(style: .Light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.bounds
        let imageView = UIImageView(frame: view.frame)
        imageView.image = UIImage(named: "snow car")
        imageView.contentMode = .ScaleAspectFill
        view.addSubview(imageView)
        view.addSubview(visualEffectView)
    }

    // MARK: - Table view data source

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
