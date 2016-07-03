//
//  DataController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 5/15/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import CoreData

class ShoppingCartController: NSObject {
    
    static let sharedInstance = ShoppingCartController()
    
    var tempItem:Item?
    
    override init() {
        super.init()
    }
    
    func createTempItem() -> Item? {
        
        if self.tempItem == nil {
        
            if let context:NSManagedObjectContext = DataController.sharedInstance.managedObjectContext {
                let ent = NSEntityDescription.entityForName("Item", inManagedObjectContext: context)
                
                let newItem = Item(entity: ent!, insertIntoManagedObjectContext: nil)
                newItem.price = 0.0
                newItem.quantity = 0
                newItem.sqFootage = 0.0
                newItem.color = "N/A"
                self.tempItem = newItem
                return self.tempItem
            }else{
                print("Failed to get managed object context: viewDidAppear")
            }
        }
        
        return nil
    }
    
    func getTotalSqFootage() -> Double? {
        
        if let customer = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if let items:NSOrderedSet = cart.items {
                    
                    var totalSqFootage:Double = 0.0
                    
                    for item in items {
                        totalSqFootage += (item as! Item).sqFootage!.doubleValue
                    }
                    
                    return totalSqFootage
                }
            }
        }
        
        return nil
    }

}
