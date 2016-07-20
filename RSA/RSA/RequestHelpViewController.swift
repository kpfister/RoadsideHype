//
//  RequestHelpViewController.swift
//  RSA
//
//  Created by Karl Pfister on 7/13/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import UIKit

class RequestHelpViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var sumbitRequestForHelp: UIButton!
    
    @IBOutlet weak var helpSummaryTextView: UITextView!

    @IBOutlet weak var nineOneOneButton: UIButton!
    
    //MARK: Actions 
    
    @IBAction func nineOneOneButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func submitRequestForHelpButtonTapped(sender: AnyObject) {
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
