//
//  LocationViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/9/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import CoreData

class LocationViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var locationPicker: UIPickerView!
    var locations:[String] = [String]()
    var locationNumbers:[Int] = [Int]()
    
    var currentLocation:Int = 0
    var currentLocationNumber:Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        
        self.locations = ["Family Room",
                          "Living Room",
                          "Kitchen",
                          "Powder Room",
                          "Dining Room",
                          "Loft",
                          "Office",
                          "Hall",
                          "Laundry",
                          "3rd Floor",
                          "French Door",
                          "Patio",
                          "Garage",
                          "Master Bedroom",
                          "Ensuite",
                          "Washroom"]
        
    }
    
    @IBAction func didPressNext(_ sender: AnyObject) {
        self.saveItemLocation()
        
    }
    
    func saveItemLocation() {
        
        self.delegate.didGetLocation("\(self.locations[self.currentLocation]) \(self.currentLocationNumber)")
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return self.locations.count
        }
        
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if component == 0 {
            return self.changePickerViewFontSize(self.locations[row])
        }
        
        return self.changePickerViewFontSize("\(row + 1)")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            self.currentLocation = row
        }else{
            self.currentLocationNumber = row + 1
        }
        
        //let title = "\(self.locations[self.currentLocation]) \(self.currentLocationNumber)"
        self.saveItemLocation()
        
    }

}
