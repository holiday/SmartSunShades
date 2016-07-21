//
//  CartItem.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 5/15/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import CoreData

class Item: NSManagedObject {
    
    

    func getHTMLTableString() -> String {
        return "<tr><td>\(self.groupName!)</td><td>\(self.location!)</td><td>\(Int(self.itemWidth!))\" \(self.getWidthFineInch().stringValue)\"</td><td>\(Int(self.itemHeight!))\" \(self.getHeightFineInch().stringValue)\"</td><td>\(self.quantity!)</td><td>\(self.color!)</td><td>\(self.fabricName!)</td></tr>"
    }
    
    func getWidthFineInch() -> (index:Int, stringValue:String) {
        if self.itemWidthFineInchIndex != nil {
            return (Int(self.itemWidthFineInchIndex!), WidthViewController.inchData[Int(self.itemWidthFineInchIndex!)])
        }
        
        print("Width fine inches data unavailable")
        return (0, "N/A")
    }
    
    func getHeightFineInch() -> (index:Int, stringValue:String) {
        if self.itemHeightFineInchIndex != nil {
            return (Int(self.itemHeightFineInchIndex!), WidthViewController.inchData[Int(self.itemHeightFineInchIndex!)])
        }
        
        print("Height fine inches data unavailable")
        return (0, "N/A")
    }

    func calculateSqFootage() {
        let width = Double(self.itemWidth!)+WidthViewController.inchValues[self.getWidthFineInch().index]
        let height = Double(self.itemHeight!)+WidthViewController.inchValues[self.getHeightFineInch().index]
        let sqInches:Double =  ((width * height) / 144.0) * Double(self.quantity!)
        let roundedSqft = Double(round(sqInches*100)/100)
        
        self.sqFootage = roundedSqft
    }

}
