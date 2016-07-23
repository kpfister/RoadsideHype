//
//  User+CoreDataProperties.swift
//  RSA
//
//  Created by Karl Pfister on 7/22/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var latitude: NSNumber
    @NSManaged var longtitude: NSNumber
    @NSManaged var phoneNumber: String
    @NSManaged var photoData: NSData?
    @NSManaged var rangeToTravel: NSNumber
    @NSManaged var userAboutMe: String
    @NSManaged var username: String

}
