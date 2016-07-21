//
//  MainViewController.swift
//  RSA
//
//  Created by Karl Pfister on 7/13/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var requestHelpButtonUnderImage: UIButton!
    
    @IBOutlet weak var requestHelp: UIButton!

    @IBOutlet weak var userButtonUnderImage: UIButton!
    
    //MARK: ACtions
    
    @IBAction func userButtonUnderImageTapped(sender: UIButton) {
    }
    
    @IBAction func requestHelpButtonTapped(sender: UIButton) {
    }
    
    @IBAction func requestButtonUnderImageTapped(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUser = UserController.sharedInstance.currentUser {
            // Run any code we need to with the current logged in user
        } else {
            // Since there is not a user, we want to present the UserTVC so the user can create an account
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
