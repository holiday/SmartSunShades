//
//  Item+CoreDataProperties.swift
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

extension Item {

    @NSManaged var fabricName:String?
    @NSManaged var color: String?
    @NSManaged var groupName: String?
    @NSManaged var itemHeight: NSNumber?
    @NSManaged var itemHeightFineInchIndex: NSNumber?
    @NSManaged var itemWidth: NSNumber?
    @NSManaged var itemWidthFineInchIndex: NSNumber?
    @NSManaged var location: String?
    @NSManaged var price: NSNumber?
    @NSManaged var quantity: NSNumber?
    @NSManaged var sqFootage: NSNumber?
    @NSManaged var cart: Cart?

}
