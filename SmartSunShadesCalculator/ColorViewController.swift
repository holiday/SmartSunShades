//
//  ColorViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/6/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var colorPickerView: UIPickerView!
    var colorData:[String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorData = ["WHITE", "OFF WHITE", "SILVER", "OLIVE", "CREAM", "IVORY", "LIGHT BEIGE", "BEIGE", "LIGHT GREY", "GREY", "CHOCOLATE", "BROWN", "MOCHA"]
        
        self.colorPickerView.delegate = self
        self.colorPickerView.dataSource = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.colorData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.colorData[row]
    }

    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = self.colorData[row]
        return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
}