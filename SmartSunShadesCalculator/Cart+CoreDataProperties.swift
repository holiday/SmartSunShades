//
//  Cart+CoreDataProperties.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 7/3/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Cart {

    @NSManaged var discountedTotal: NSNumber?
    @NSManaged var discountPercent: NSNumber?
    @NSManaged var subTotal: NSNumber?
    @NSManaged var customers: Customers?
    @NSManaged var items: NSOrderedSet?

}
