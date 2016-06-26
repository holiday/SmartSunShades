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

class CategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

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
    
    @IBAction func didPressAddToCart(sender: UIButton) {
        
        //add the temp item to the shopping cart
        //updated the width in shopping cart
        let shoppingCart = ShoppingCartController.sharedInstance.shoppingCart
        
        if shoppingCart.moveTempItemToCart() == true {
            
            print("Successfully added tempItem to cart")
            
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("cartViewController") as! CartViewController
        
        self.presentViewController(vc, animated: true) {
            
            //self.navigationController?.popToRootViewControllerAnimated(false)
            let vc = self.navigationController?.viewControllers[1]
            self.navigationController?.popToViewController(vc!, animated: true)
        }
        
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categoryTitles.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categoryTitles[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = self.categoryTitles[row]
        return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.currentSelectedCategoryIndex = row
        self.computeItemPrice()
        
    }
    
    func computeItemPrice() {
        self.currentSelectedCategory = self.categoryTitles[self.currentSelectedCategoryIndex]
        
        let pt = PriceTable(fileName: self.categoryFileNames[self.currentSelectedCategoryIndex], fileExtension: "csv")
        
        
        //updated the category in shopping cart
        let shoppingCart = ShoppingCartController.sharedInstance.shoppingCart
        
        let tempItem = shoppingCart.getTempItem()
        tempItem.groupName = self.categoryTitles[self.currentSelectedCategoryIndex]
        
        let price = pt.getPrice(tempItem.getItemWidth(), widthFineInchIndex: tempItem.getWidthFineInch().index, height: tempItem.getItemHeight(), heightFineInchIndex: tempItem.getHeightFineInch().index)
        
        let width = tempItem.getItemWidth()+WidthViewController.inchValues[tempItem.getWidthFineInch().index]
        let height = tempItem.getItemHeight()+WidthViewController.inchValues[tempItem.getHeightFineInch().index]
        let sqft:Double =  width * height * Double(tempItem.quantity!)
        let roundedSqft = Double(round(sqft*100)/100)
        
        tempItem.sqft = roundedSqft
        tempItem.price = Double(tempItem.quantity!) * price
    }
    

}

