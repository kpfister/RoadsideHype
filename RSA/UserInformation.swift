//
//  UserInformation.swift
//  RSA
//
//  Created by Karl Pfister on 7/27/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import Foundation
import CloudKit

// May need this for V.2.

class UserInformation {
    
    var latitude: Float
    var longtitude: Float
    var phoneNumber: String
    var photoData: NSData?
    var rangeToTravel: Float
    var userAboutMe: String
    var username: String
    
    
    
    init?(record: CKRecord) {
        guard let latitude = record["latitude"] as? Float,
            let longtitude = record["longtitude"] as? Float,
            let phoneNumber = record["phoneNumber"] as? String,
            let rangeToTravel = record["rangeToTravel"] as? Float,
            let userAboutMe = record["userAboutMe"] as? String,
            let username = record["username"] as? String,
            let photoData = record["photoData"] as? CKAsset else {
                return nil
        }
        self.latitude = latitude
        self.longtitude = longtitude
        self.phoneNumber = phoneNumber
        self.photoData = NSData(contentsOfURL: photoData.fileURL)
        self.rangeToTravel = rangeToTravel
        self.userAboutMe = userAboutMe
        self.username = username
    }
        
}