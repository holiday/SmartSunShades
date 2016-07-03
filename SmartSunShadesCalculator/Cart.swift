//
//  Cart.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 6/29/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import Foundation
import CoreData

class Cart: NSManagedObject {
//
//    func updateTotal() {
//        subTotal = 0.0
//        for item in cartItems {
//            if item.price != nil {
//                subTotal += item.price!
//            }
//        }
//    }
//    
//    func addTempItem(item:Item) {
//        self.tempItem = item
//    }
//    
//    func getTempItem() -> Item {
//        return self.tempItem!
//    }
//    
//
//    func addItem(item:Item) {
//        self.cartItems.append(item)
//        self.updateTotal()
//    }
//    
//    func getItem(index:Int) -> Item? {
//        if index <= self.cartItems.count-1 && index >= 0{
//            return self.cartItems[index]
//        }
//        
//        return nil
//    }
//    
//    func setColorForItem(item:Item, color:String){
//        item.color = color
//    }
//    
//    func deleteItem(index:Int) {
//        if index <= self.cartItems.count-1 && index >= 0{
//            self.cartItems.removeAtIndex(index)
//        }
//    }
    
    func calculateSubtotal(){
        self.subTotal = NSNumber(double: 0.0)
        
        for item in self.items! {
            if let item = item as? Item {
                if item.price != nil {
                    self.subTotal = NSNumber(double: self.subTotal!.doubleValue + item.price!.doubleValue)
                }
            }
        }
    }
  
    func getFiftyOff() -> Double {
        return self.subTotal!.doubleValue / 2.00
    }
    
    func getTotal() -> Double{
        self.calculateDiscountedTotal()
        return self.subTotal!.doubleValue - self.discountedTotal!.doubleValue
    }

    func getDiscountedTotal() -> Double {
        self.calculateDiscountedTotal()
        return self.discountedTotal!.doubleValue
    }
    
    func calculateDiscountedTotal() {
        self.calculateSubtotal()
        
        let dt:Double = (self.subTotal!.doubleValue/2.0) + ((self.discountPercent!.doubleValue/100) * (self.subTotal!.doubleValue/2.0))
        
        self.discountedTotal = NSNumber(double: dt)
    }

}
