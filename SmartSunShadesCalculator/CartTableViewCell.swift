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
    
    func populateTableCell(item:Item){
        if item.groupName != nil {
            self.groupName.text = item.groupName!
        }
        
        if item.itemWidth != nil {
            self.widthLabel.text = "Width: \(item.itemWidth!) \(WidthViewController.inchData[item.itemWidthFineInchIndex!])"
        }
        
        if item.itemHeight != nil {
            self.heightLabel.text = "Height: \(item.itemHeight!) \(WidthViewController.inchData[item.itemHeightFineInchIndex!])"
        }
        
        if item.quantity != nil {
            self.quantityLabel.text = "Qty: \(item.quantity!)"
        }
        
        if item.price != nil {
            self.priceLabel.text = "$\(item.price!)"
        }
    }
    
}
