//
//  ShoppingCart.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 5/15/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import CoreData

class ShoppingCart: NSObject {
    
    var tempItem:Item!
    var cartItems:[Item] = [Item]()
    var subTotal:Double = 0.0
    var discountPercent:Double = 0.0
    var discountedTotal:Double = 0.0
    
    func updateTotal() {
        subTotal = 0.0
        for item in cartItems {
            if item.price != nil {
                subTotal += item.price!
            }
        }
    }
    
    func addTempItem(item:Item) {
        self.tempItem = item
    }
    
    func getTempItem() -> Item {
        return self.tempItem!
    }
    
    func moveTempItemToCart() -> Bool {
        if tempItem != nil {
            cartItems.append(self.tempItem)
            self.updateTotal()
            self.tempItem = nil
            return true
        }
        
        
        return false
    }
    
    func addItem(item:Item) {
        self.cartItems.append(item)
        self.updateTotal()
    }
    
    func getItem(index:Int) -> Item? {
        if index <= self.cartItems.count-1 && index >= 0{
            return self.cartItems[index]
        }
        
        return nil
    }
    
    func setColorForItem(item:Item, color:String){
        item.color = color
    }
    
    func deleteItem(index:Int) {
        if index <= self.cartItems.count-1 && index >= 0{
            self.cartItems.removeAtIndex(index)
        }
    }
    
    func getFiftyOff() -> Double {
        return self.subTotal / 2.00
    }
    
    func getTotalSqInches() -> Double {
        var totalSqInches = 0.0
        for item in cartItems{
            totalSqInches += item.sqInches!
        }
        
        return totalSqInches
    }
    
    func getTotal() -> Double{
        self.calculateDiscountedTotal()
        return self.subTotal - self.discountedTotal
    }
    
    func getDiscountedTotal() -> Double {
        self.calculateDiscountedTotal()
        return self.discountedTotal
    }
    
    func calculateDiscountedTotal() {
        
        self.discountedTotal = (self.subTotal/2.0) + ((self.discountPercent/100) * (self.subTotal/2.0))
    }
}
