//
//  CartItem.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 5/15/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class Item: NSObject {
    
    var groupName:String?
    var location:String?
    var itemWidth:Double?
    var itemWidthFineInchIndex:Int?
    var itemHeight:Double?
    var itemHeightFineInchIndex:Int?
    var quantity:Int?
    var price:Double?
    
    init(location:String?, width:Double?, height:Double?, quantity:Int?) {
        
        if location != nil {
            self.location = location!
        }
        
        if width != nil {
            self.itemWidth = width!
        }
        
        if height != nil {
            self.itemHeight = height!
        }
        
        if quantity != nil {
            self.quantity = quantity!
        }
    }
    
    func getGroupName() -> String {
        if self.groupName != nil {
            return self.groupName!
        }
        
        print("Group name not set")
        return "N/A"
    }
    
    func getLocation() -> String {
        if self.location != nil {
            return self.location!
        }
        print("Item location not set")
        return "N/A"
    }
    
    func getItemWidth() -> Double {
        if self.itemWidth != nil {
            return self.itemWidth!
        }
        
        return 0.0
    }
    
    func getItemHeight() -> Double {
        if self.itemHeight != nil {
            return self.itemHeight!
        }
        
        return  0.0
    }
    
    func getQuantity() -> Int {
        if self.quantity != nil {
            return self.quantity!
        }
        
        return 0
    }
    
    func getPrice() -> Double {
        if self.price != nil {
            return self.price!
        }
        
        return 0.00
    }
    
    func getHTMLTableString() -> String {
        return "<tr><td>\(self.groupName!)</td><td>\(self.getLocation())</td><td>\(self.getItemWidth())\" \(self.getWidthFineInch().stringValue)\" inches</td><td>\(self.getItemHeight())\" \(self.getHeightFineInch().stringValue)\" inches</td><td>\(self.getQuantity())</td></tr>"
    }
    
    func getWidthFineInch() -> (index:Int, stringValue:String) {
        if self.itemWidthFineInchIndex != nil {
            return (self.itemWidthFineInchIndex!, WidthViewController.inchData[self.itemWidthFineInchIndex!])
        }
        
        print("Width fine inches data unavailable")
        return (0, "N/A")
    }
    
    func getHeightFineInch() -> (index:Int, stringValue:String) {
        if self.itemHeightFineInchIndex != nil {
            return (self.itemHeightFineInchIndex!, WidthViewController.inchData[self.itemHeightFineInchIndex!])
        }
        
        print("Height fine inches data unavailable")
        return (0, "N/A")
    }

}
