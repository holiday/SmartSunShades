//
//  LocationViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/9/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import CoreData

class LocationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var locationPicker: UIPickerView!
    var locations:[String] = [String]()
    var locationNumbers:[Int] = [Int]()
    
    var currentLocation:Int = 0
    var currentLocationNumber:Int = 1
    
    let shoppingCartController = ShoppingCartController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        
        self.locations = ["Family Room",
                          "Living Room",
                          "Kitchen",
                          "Powder Room",
                          "Dining Room",
                          "Hall",
                          "Laundry",
                          "French Door",
                          "Patio",
                          "Room 1",
                          "Room 2",
                          "Room 3",
                          "Room 4",
                          "Master Bedroom",
                          "Ensuite",
                          "Washroom"]
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //Create a temp Item
        ShoppingCartController.sharedInstance.createTempItem()
        
    }
    
    @IBAction func didPressNext(sender: AnyObject) {
        
        self.saveItemLocation()
        
    }
    
    func saveItemLocation() {
        
        if let tempItem = self.shoppingCartController.tempItem {
            tempItem.location = "\(self.locations[self.currentLocation]) \(self.currentLocationNumber)"
            
            print(tempItem.location)
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return self.locations.count
        }
        
        return 6
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.locations[row]
        }
        
        return "\(row + 1)"
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var title = ""
        
        if component == 0 {
            title = self.locations[row]
        }else{
            title = "\(row + 1)"
        }
        
        return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            self.currentLocation = row
        }else{
            self.currentLocationNumber = row + 1
        }
        
        //let title = "\(self.locations[self.currentLocation]) \(self.currentLocationNumber)"
        self.saveItemLocation()
        
    }

}
