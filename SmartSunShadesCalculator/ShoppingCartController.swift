//
//  DataController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 5/15/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import CoreData

protocol ShoppingCartControllerDelegate {
    func didGetLocation(location:String)
    func didGetFabric(fabric:String)
    func didGetWidthData(itemWidth:Double, itemWidthIndex:Int)
    func didGetHeightData(itemHeight:Double, itemHeightIndex:Int)
    func didGetQuantity(quantity:Int)
    func didGetCategory(groupName:String, groupFileName:String)
    
}

public class ShoppingCartController: NSObject, ShoppingCartControllerDelegate {
    
    static let sharedInstance = ShoppingCartController()
    
    var tempItem:Item?
    
    override init() {
        super.init()
        self.createTempItem()
    }
    
    public func createTempItem() -> Bool {
        
        if self.tempItem == nil {
        
            if let context:NSManagedObjectContext = DataController.sharedInstance.managedObjectContext {
                let ent = NSEntityDescription.entityForName("Item", inManagedObjectContext: context)
                
                let newItem = Item(entity: ent!, insertIntoManagedObjectContext: nil)
                newItem.price = 0.0
                newItem.quantity = 0
                newItem.sqFootage = 0.0
                newItem.color = "N/A"
                self.tempItem = newItem
                return true
            }else{
                print("Failed to get managed object context: viewDidAppear")
            }
        }
        
        return false
    }
    
    func didGetLocation(location: String) {
        if let tempItem:Item = ShoppingCartController.sharedInstance.tempItem {
            tempItem.location = location
            
            print("Item Location updated: \(location)")
        }
    }
    
    func didGetFabric(fabric: String) {
        if let tempItem:Item = ShoppingCartController.sharedInstance.tempItem {
            tempItem.fabricName = fabric
            
            print("Fabric Name updated: \(fabric)")
        }
    }
    
    func didGetWidthData(itemWidth: Double, itemWidthIndex: Int) {
        if let tempItem:Item = ShoppingCartController.sharedInstance.tempItem {
            tempItem.itemWidth = itemWidth
            tempItem.itemWidthFineInchIndex = itemWidthIndex
            
            print("Width Changed: \(tempItem.itemWidth) , \(tempItem.getWidthFineInch().stringValue)")
        }
    }
    
    func didGetHeightData(itemHeight: Double, itemHeightIndex: Int) {
        if let tempItem:Item = ShoppingCartController.sharedInstance.tempItem {
            tempItem.itemHeight = itemHeight
            tempItem.itemHeightFineInchIndex = itemHeightIndex
            
            print("Height Changed: \(tempItem.itemHeight) , \(tempItem.getHeightFineInch().stringValue)")
        }
    }
    
    func didGetQuantity(quantity: Int) {
        if let tempItem:Item = ShoppingCartController.sharedInstance.tempItem {
            tempItem.quantity = quantity
            
            print("Quantity updated: \(quantity)")
        }
    }
    
    func didGetCategory(groupName: String, groupFileName: String) {
        if let tempItem:Item = ShoppingCartController.sharedInstance.tempItem {
            tempItem.groupFileName = groupFileName
            tempItem.groupName = groupName
            
            print("Category updated: \(groupName)")
        }
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
