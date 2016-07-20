//
//  SyncableObject+CoreDataProperties.swift
//  RSA
//
//  Created by Karl Pfister on 7/14/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SyncableObject {

    @NSManaged var recordName: String
    @NSManaged var timestamp: NSDate
    @NSManaged var recordIDData: NSData?

}
