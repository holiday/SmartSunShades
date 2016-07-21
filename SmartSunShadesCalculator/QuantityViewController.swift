//
//  QuantityViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/6/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class QuantityViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var quantityPickerView: UIPickerView!
    
    var currentQuantity:Int = 1
    
    var delegate:ShoppingCartControllerDelegate = ShoppingCartController.sharedInstance
    
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
        self.delegate.didGetQuantity(self.currentQuantity)
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        return self.changePickerViewFontSize("\(row+1)")
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
    

