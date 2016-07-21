//
//  WidthViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/6/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class WidthViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var widthPickerView: UIPickerView!
    var currentPickerView:UIPickerView!
    var inchesData:[Double] = [Double]()
    static var inchData:[String] = ["0", "1/8", "1/4", "3/8", "1/2", "5/8", "3/4", "7/8"]
    static var inchValues:[Double] = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875]
    
    var currentIndex:Int = 0
    var currentInchIndex:Int = 0
    
    var delegate:ShoppingCartControllerDelegate = ShoppingCartController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if widthPickerView != nil {
            self.currentPickerView = widthPickerView
        }
        
        self.populateInchesData(&self.inchesData, from: 12, to: 108)
        
        self.currentPickerView.delegate = self
        self.currentPickerView.dataSource = self
        
    }
    
    @IBAction func didPressNext(sender: AnyObject) {
        
        self.saveWidthData()
        
    }
    
    func saveWidthData() {
        
        self.delegate.didGetWidthData(self.inchesData[self.currentIndex], itemWidthIndex: self.currentInchIndex)
        
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        if component == 0 {
            return self.changePickerViewFontSize("\(Int(self.inchesData[row])) inches")
        }
        
        return self.changePickerViewFontSize("\(WidthViewController.inchData[row])")
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
