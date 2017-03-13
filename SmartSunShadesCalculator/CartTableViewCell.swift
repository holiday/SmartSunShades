//
//  CartTableViewCell.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 5/15/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import CoreData

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var sqInchesLabel:UILabel!
    @IBOutlet weak var colorLabel:UILabel!
    @IBOutlet weak var fabricNameLabel:UILabel!
    
    //Other prices
    @IBOutlet weak var twoInchBlindsPrice:UILabel!
    @IBOutlet weak var rollerShadesPrice:UILabel!
    @IBOutlet weak var tripleShades100:UILabel!
    
    
    var itemId:NSManagedObjectID!
    
    func populateTableCell(_ item:Item){
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                if let location = item.location {
                    self.locationLabel.text = "Location: \(location)"
                }
                
                if let groupName = item.groupName {
                    self.groupName.text = groupName
                }
                
                if item.itemWidth != nil {
                    self.widthLabel.text = "Width: \(Int(item.itemWidth!))\" \(WidthViewController.inchData[Int(item.itemWidthFineInchIndex!)])\""
                }
                
                if item.itemHeight != nil {
                    self.heightLabel.text = "Height: \(Int(item.itemHeight!))\" \(WidthViewController.inchData[Int(item.itemHeightFineInchIndex!)])\""
                }
                
                if item.quantity != nil {
                    self.quantityLabel.text = "Qty: \(item.quantity!)"
                }
                
                if let price = item.price {
                    self.priceLabel.text = "Solar Shades 5: $\(price)"
                    
                    if let priceOne = item.getPrice(groupName: "2 Inch Faux Wood Blinds", groupFileName: "2_inch_faux_wood_blinds") {
                        self.twoInchBlindsPrice.text = "2 \" Blinds: $\(priceOne * Double(item.quantity!))"
                    }
                    
                    if let priceTwo = item.getPrice(groupName: "Roller Shades 3", groupFileName: "roller_shades_3") {
                        self.rollerShadesPrice.text = "Shades 3: $\(priceTwo * Double(item.quantity!))"
                    }
                    
                    if let priceThree = item.getPrice(groupName: "Triple Shades Sapphire 100", groupFileName: "triple_shades_sapphire_100") {
                        self.tripleShades100.text = "Vienna 100: $\(priceThree * Double(item.quantity!))"
                    }
                    
                }

                if item.sqFootage != nil {
                    self.sqInchesLabel.text = "Square Footage: \(item.sqFootage!)"
                }
                
                if item.color != nil {
                    self.colorLabel.text = "Color: \(item.color!)"
                }
                
                if item.fabricName != nil {
                    self.fabricNameLabel.text = "Fabric Name: \(item.fabricName!)"
                }
                
                self.itemId = item.objectID
            }
        }
    }
    
}
