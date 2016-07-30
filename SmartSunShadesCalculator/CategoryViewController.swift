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
    var categoryTitles: [String]!
    var categoryFileNames: [String]!
    var currentSelectedCategory:String?
    var currentSelectedCategoryIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryTitles = ["Dual Solar Shades - Group 3",
                               "Dual Solar Shades - Group 4",
                               "Dual Solar Shades - Group 5",
                               "Roller Shades 3",
                               "Triple Shades Sapphire 75",
                               "Triple Shades Sapphire 100"]
        
        self.categoryFileNames = ["dual_solar_shades_3",
                               "dual_solar_shades_4",
                               "dual_solar_shades_5",
                               "roller_shades_3",
                               "triple_shades_sapphire_75",
                               "triple_shades_sapphire_100"]
        
        // Connect data:
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //compute the item price
        self.computeItemPrice()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.delegate.didGetCategory(self.categoryTitles[self.currentSelectedCategoryIndex], groupFileName: self.categoryFileNames[self.currentSelectedCategoryIndex])
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categoryTitles.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        return self.changePickerViewFontSize(self.categoryTitles[row])
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = self.categoryTitles[row]
        return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.currentSelectedCategoryIndex = row
        
        self.delegate.didGetCategory(self.categoryTitles[self.currentSelectedCategoryIndex], groupFileName: self.categoryFileNames[self.currentSelectedCategoryIndex])
        self.computeItemPrice()
        
    }
    
    func computeItemPrice() {
        self.currentSelectedCategory = self.categoryTitles[self.currentSelectedCategoryIndex]
        
        //updated the category in shopping cart
        
        if let tempItem = ShoppingCartController.sharedInstance.tempItem {
            
            let pt = PriceTable(fileName: self.categoryFileNames[self.currentSelectedCategoryIndex], fileExtension: "csv")
            
            tempItem.groupFileName = self.categoryFileNames[self.currentSelectedCategoryIndex]
            
            tempItem.groupName = self.categoryTitles[self.currentSelectedCategoryIndex]
            
            let price = pt.getPrice(Double(tempItem.itemWidth!), widthFineInchIndex: tempItem.getWidthFineInch().index, height: Double(tempItem.itemHeight!), heightFineInchIndex: tempItem.getHeightFineInch().index)
            
            tempItem.calculateSqFootage()
            
            tempItem.price = Double(tempItem.quantity!) * price
            print(tempItem.price)
        }else{
            print("Failed to compute price, temp item not available")
        }
        
    }
    

}

