//
//  FabricViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 6/29/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class FabricViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var fabricPickerView: UIPickerView!
    var fabricNames: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fabricNames = ["SERENA",
                               "RUBY",
                               "EMERALD",
                               "ROSE",
                               "ASTER",
                               "AMBER", "GALAXY", "SANA", "SUMMER", "ZMC", "DIAMOND", "SAPHIRE75", "SAPHIRE100", "SKY", "OCEAN", "CLOUD9", "BLACKBERRY"]
        
        // Connect data:
        self.fabricPickerView.delegate = self
        self.fabricPickerView.dataSource = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //updated the category in shopping cart
        let shoppingCart = ShoppingCartController.sharedInstance.shoppingCart
        let tempItem = shoppingCart.getTempItem()
        tempItem.fabricName = self.fabricNames[0]
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
        return self.fabricNames.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.fabricNames[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = self.fabricNames[row]
        return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //updated the category in shopping cart
        let shoppingCart = ShoppingCartController.sharedInstance.shoppingCart
        let tempItem = shoppingCart.getTempItem()
        tempItem.fabricName = self.fabricNames[row]
    }
    
}


