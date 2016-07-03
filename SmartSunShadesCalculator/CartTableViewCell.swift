//
//  CartTableViewCell.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 5/15/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var sqInchesLabel:UILabel!
    @IBOutlet weak var colorLabel:UILabel!
    @IBOutlet weak var fabricNameLabel:UILabel!
    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        self.selectedBackgroundView = self.backgroundView
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    func populateTableCell(item:Item){
        if item.groupName != nil {
            self.groupName.text = item.groupName!
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
        
        if item.price != nil {
            self.priceLabel.text = "$\(item.price!)"
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
    }
    
}
