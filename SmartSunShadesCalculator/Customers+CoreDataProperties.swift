//
//  Customers+CoreDataProperties.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 6/29/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Customers {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var address: String?
    @NSManaged var email: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var cart: NSManagedObject?
    @NSManaged var order: NSManagedObject?

}
