//
//  ViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/3/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

protocol CategoryViewDelegate {
    func getCurrentSelectedCategory() -> String;
}

class CategoryViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var categoryPickerView: UIPickerView!
    static var categoryTitles: [String] = ["Dual Solar Shades - Group 3",
                                           "Dual Solar Shades - Group 4",
                                           "Dual Solar Shades - Group 5",
                                           "Roller Shades 3",
                                           "Triple Shades Sapphire 75",
                                           "Triple Shades Sapphire 100",
                                           "2 Inch Faux Wood Blinds"]
    
    static var categoryFileNames: [String] = ["dual_solar_shades_3",
                                        "dual_solar_shades_4",
                                        "dual_solar_shades_5",
                                        "roller_shades_3",
                                        "triple_shades_sapphire_75",
                                        "triple_shades_sapphire_100",
                                        "2_inch_faux_wood_blinds"]
    
    var currentSelectedCategory:String?
    var currentSelectedCategoryIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //compute the item price
//        self.computeItemPrice()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate.didGetCategory(CategoryViewController.categoryTitles[self.currentSelectedCategoryIndex], groupFileName: CategoryViewController.categoryFileNames[self.currentSelectedCategoryIndex])
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CategoryViewController.categoryTitles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return self.changePickerViewFontSize(CategoryViewController.categoryTitles[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.currentSelectedCategoryIndex = row
        
        self.delegate.didGetCategory(CategoryViewController.categoryTitles[self.currentSelectedCategoryIndex], groupFileName: CategoryViewController.categoryFileNames[self.currentSelectedCategoryIndex])
//        self.computeItemPrice()
        
    }
    
//    func computeItemPrice() {
//        self.currentSelectedCategory = CategoryViewController.categoryTitles[self.currentSelectedCategoryIndex]
//        
//        //updated the category in shopping cart
//        
//        if let tempItem = ShoppingCartController.sharedInstance.tempItem {
//            
//            let groupFileName = CategoryViewController.categoryFileNames[self.currentSelectedCategoryIndex]
//            
//            let groupName = CategoryViewController.categoryTitles[self.currentSelectedCategoryIndex]
//            
//            if let price = tempItem.getPrice(groupName: groupName, groupFileName: groupFileName) {
//                tempItem.price = price as NSNumber?
//            }else{
//                tempItem.price = 0.0
//            }
//            
//            tempItem.calculateSqFootage()
//        }else{
//            print("Failed to compute price, temp item not available")
//        }
//        
//    }
    

}

