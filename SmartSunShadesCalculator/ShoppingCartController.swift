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
    func didGetLocation(_ location:String)
    func didGetFabric(_ fabric:String)
    func didGetWidthData(_ itemWidth:Double, itemWidthIndex:Int)
    func didGetHeightData(_ itemHeight:Double, itemHeightIndex:Int)
    func didGetQuantity(_ quantity:Int)
    func didGetCategory(_ groupName:String, groupFileName:String)
    
}

open class ShoppingCartController: NSObject, ShoppingCartControllerDelegate {
    
    static let sharedInstance = ShoppingCartController()
    
    var tempItem:Item?
    
    override init() {
        super.init()
        self.createTempItem()
    }
    
    open func createTempItem() {
        
        if self.tempItem == nil {
        
            if let context:NSManagedObjectContext = DataController.sharedInstance.managedObjectContext {
                let ent = NSEntityDescription.entity(forEntityName: "Item", in: context)
                
                let newItem = Item(entity: ent!, insertInto: nil)
                newItem.price = 0.0
                newItem.quantity = 0
                newItem.sqFootage = 0.0
                newItem.color = ""
                newItem.fabricName = ""
                self.tempItem = newItem
            }else{
                print("Failed to get managed object context: viewDidAppear")
            }
        }
    }
    
    func didGetLocation(_ location: String) {
        if let tempItem:Item = ShoppingCartController.sharedInstance.tempItem {
            tempItem.location = location
            
            print("Item Location updated: \(location)")
        }
    }
    
    func didGetFabric(_ fabric: String) {
        if let tempItem:Item = ShoppingCartController.sharedInstance.tempItem {
            tempItem.fabricName = fabric
            
            print("Fabric Name updated: \(fabric)")
        }
    }
    
    func didGetWidthData(_ itemWidth: Double, itemWidthIndex: Int) {
        if let tempItem:Item = ShoppingCartController.sharedInstance.tempItem {
            tempItem.itemWidth = itemWidth as NSNumber?
            tempItem.itemWidthFineInchIndex = itemWidthIndex as NSNumber?
            
            print("Width Changed: \(tempItem.itemWidth) , \(tempItem.getWidthFineInch().stringValue)")
        }
    }
    
    func didGetHeightData(_ itemHeight: Double, itemHeightIndex: Int) {
        if let tempItem:Item = ShoppingCartController.sharedInstance.tempItem {
            tempItem.itemHeight = itemHeight as NSNumber?
            tempItem.itemHeightFineInchIndex = itemHeightIndex as NSNumber?
            
            print("Height Changed: \(tempItem.itemHeight) , \(tempItem.getHeightFineInch().stringValue)")
        }
    }
    
    func didGetQuantity(_ quantity: Int) {
        if let tempItem:Item = ShoppingCartController.sharedInstance.tempItem {
            tempItem.quantity = quantity as NSNumber?
            
            print("Quantity updated: \(quantity)")
        }
    }
    
    func didGetCategory(_ groupName: String, groupFileName: String) {
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
