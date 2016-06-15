//
//  HeightViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/6/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class HeightViewController: WidthViewController {
    
    @IBOutlet weak var heightPickerView: UIPickerView!

    override func viewDidLoad() {
        
        self.currentPickerView = heightPickerView
        
        super.viewDidLoad()
        
        self.populateInchesData(&self.inchesData, from: 12, to: 120)
    }
    
    @IBAction override func didPressNext(sender: AnyObject) {
        self.saveHeightData()
    }
    
    func saveHeightData() {
        //updated the width in shopping cart
        let shoppingCart = ShoppingCartController.sharedInstance.shoppingCart
        
        let tempItem:Item = shoppingCart.getTempItem()
        
        tempItem.itemHeight = self.inchesData[self.currentIndex]
        tempItem.itemHeightFineInchIndex = self.currentInchIndex
        
        print("Width: \(tempItem.getItemHeight()) , \(tempItem.getHeightFineInch().stringValue)")
    }
    
    override func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            self.currentIndex = row
        }else{
            self.currentInchIndex = row
        }
        
        self.saveHeightData()
        
    }
}
