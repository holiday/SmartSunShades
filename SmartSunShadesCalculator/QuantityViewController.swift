//
//  QuantityViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/6/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class QuantityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var quantityPickerView: UIPickerView!
    
    var currentQuantity:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quantityPickerView.delegate = self
        self.quantityPickerView.dataSource = self
    }
    
    @IBAction func didPressNext(sender: AnyObject) {
        self.saveQuantityData()
    }
    
    func saveQuantityData() {
        
        //updated the width in shopping cart
        
        if let tempItem:Item = ShoppingCartController.sharedInstance.tempItem {
            tempItem.quantity = self.currentQuantity
            
            print("Quantity: \(tempItem.quantity)")
        }else {
            print("Error getting tempItem: saveQuantityData")
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)"
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = "\(row+1)"
        return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.currentQuantity = row+1
        
        self.saveQuantityData()
        
    }

}
    

