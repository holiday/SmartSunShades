//
//  ColorViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/6/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

protocol ColorViewControllerDelegate {
    func didSelectColor(color:String, indexPath:NSIndexPath)
}

class ColorViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var colorPickerView: UIPickerView!
    var colorData:[String] = [String]()
    var delegate:ColorViewControllerDelegate?
    var indexPath:NSIndexPath?
//    var delegate:ShoppingCartControllerDelegate = ShoppingCartController.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorData = ["WHITE", "OFF WHITE", "SILVER", "OLIVE", "CREAM", "IVORY", "LIGHT BEIGE", "BEIGE", "LIGHT GREY", "GREY", "CHOCOLATE", "BROWN", "MOCHA"]
        
        self.colorPickerView.delegate = self
        self.colorPickerView.dataSource = self
    }
    
    @IBAction func didPressDone(sender: AnyObject) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let title = self.colorData[row]
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.whiteColor()
        pickerLabel.text = title
        pickerLabel.font = UIFont(name: "Helvetica Neue", size: 28)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (self.delegate != nil && self.indexPath != nil) {
            self.delegate?.didSelectColor(self.colorData[row], indexPath: self.indexPath!)
        }
    }
    
}