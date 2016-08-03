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
    
    func getRoundedDecimal(number:Double) -> Double {
        return Double(round(number*100)/100)
    }
    
    func getTotalSquareFootage() -> Double {
        var totalSqFootage:Double = 0.0
        
        for item in self.items! {
            if let item = item as? Item {
                if item.sqFootage != nil {
                    totalSqFootage += Double(item.sqFootage!)
                }
            }
        }
        
        return totalSqFootage
    }
    
    func getTotalQuantity() -> Int {
        var totalQuantity:Int = 0
        
        for item in self.items! {
            if let item = item as? Item {
                if item.quantity != nil {
                    totalQuantity += Int(item.quantity!)
                }
            }
        }
        
        return totalQuantity
    }
    
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
    
    func getBalance() -> Double{
        self.getDiscountedTotal()
        
        let priceBeforeTax = self.subTotal!.doubleValue - self.discountedTotal!.doubleValue
        let priceAfterTax = priceBeforeTax * (1 + (self.tax!.doubleValue/100.0))
        let priceAfterDeposit = priceAfterTax - self.deposit!.doubleValue
        
        return priceAfterDeposit
    }
    
    func getTotal() -> Double{
        self.getDiscountedTotal()
        
        let priceBeforeTax = self.subTotal!.doubleValue - self.discountedTotal!.doubleValue
        let priceAfterTax = priceBeforeTax * (1 + (self.tax!.doubleValue/100.0))
        
        return priceAfterTax
    }

    func getDiscountedTotal() -> Double {
        self.calculateSubtotal()
        
        let dt:Double = (self.subTotal!.doubleValue/2.0) + ((self.discountPercent!.doubleValue/100) * (self.subTotal!.doubleValue/2.0))
        
        self.discountedTotal = NSNumber(double: dt)
        return self.discountedTotal!.doubleValue
    }

}
