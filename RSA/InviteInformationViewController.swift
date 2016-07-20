//
//  InviteInformationViewController.swift
//  RSA
//
//  Created by Karl Pfister on 7/13/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import UIKit

class InviteInformationViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var theirUsername: UILabel!

    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var summary: UILabel!
    
    @IBOutlet weak var rangeWillingToTravel: UILabel!
    
    @IBOutlet weak var primaryLocation: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!
    
    //MARK: Actions
    
    @IBAction func acceptButtonTapped(sender: UIButton) {
    }
    
    @IBAction func declineButtonTapped(sender: UIButton) {
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
