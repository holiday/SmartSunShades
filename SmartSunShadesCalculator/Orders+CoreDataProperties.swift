//
//  Orders+CoreDataProperties.swift
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

extension Orders {

    @NSManaged var orderDate: NSDate?
    @NSManaged var expectedDelivery: NSDate?
    @NSManaged var customers: Customers?
    
}
