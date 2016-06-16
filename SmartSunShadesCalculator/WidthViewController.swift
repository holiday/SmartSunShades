//
//  WidthViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/6/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class WidthViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var widthPickerView: UIPickerView!
    var currentPickerView:UIPickerView!
    var inchesData:[Double] = [Double]()
    static var inchData:[String] = ["0", "1/8", "2/8", "3/8", "4/8", "5/8", "6/8", "7/8"]
    
    var currentIndex:Int = 0
    var currentInchIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if widthPickerView != nil {
            self.currentPickerView = widthPickerView
        }
        
        self.populateInchesData(&self.inchesData, from: 12, to: 96)
        
        self.currentPickerView.delegate = self
        self.currentPickerView.dataSource = self
        
    }
    
    @IBAction func didPressNext(sender: AnyObject) {
        
        self.saveWidthData()
        
    }
    
    func saveWidthData() {
        //updated the width in shopping cart
        let shoppingCart = ShoppingCartController.sharedInstance.shoppingCart
        
        let tempItem:Item = shoppingCart.getTempItem()
        
        tempItem.itemWidth = self.inchesData[self.currentIndex]
        tempItem.itemWidthFineInchIndex = self.currentInchIndex
        
        print("Width: \(tempItem.getItemWidth()) , \(tempItem.getWidthFineInch().stringValue)")
    }
    
    override func viewDidAppear(animated: Bool) {
        //self.currentPickerView.selectRow(25, inComponent: 0, animated: true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return inchesData.count
        }
        return WidthViewController.inchData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(Int(self.inchesData[row])) inches"
        }
        
        return WidthViewController.inchData[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if component == 0 {
            let title = "\(Int(self.inchesData[row])) inches"
            return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        }
        
        let title = WidthViewController.inchData[row]
        return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            self.currentIndex = row
        }else{
            self.currentInchIndex = row
        }
        
        self.saveWidthData()
    }
    
    func populateInchesData(inout dataArray:[Double], from:Int, to:Int){
        //Populate the array of inches
        for i in from...to {
            dataArray.append(Double(i))
        }
    }

}
