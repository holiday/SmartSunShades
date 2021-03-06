//
//  FabricViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 6/29/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import CoreData

class FabricViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        //updated the category in shopping cart
        if let tempItem = ShoppingCartController.sharedInstance.tempItem {
            tempItem.fabricName = self.fabricNames[0]
        }
    }
    
//    @IBAction func didPressAddToCart(_ sender: UIButton) {
//        
//        //add the temp item to the shopping cart
//        //updated the width in shopping cart
//        if let customer:Customers = DataController.sharedInstance.customer {
//            if let cart:Cart = customer.cart as? Cart{
//                if let context = DataController.sharedInstance.managedObjectContext {
//                    if let tempItem = ShoppingCartController.sharedInstance.tempItem {
//                        context.insert(tempItem)
//                        tempItem.cart = cart
//                        tempItem.calculateDefaultPrice()
//                        do {
//                            try context.save()
//                            
//                            //Cleanup, remove temp item
//                            ShoppingCartController.sharedInstance.tempItem = nil
//                            ShoppingCartController.sharedInstance.createTempItem()
//                            
//                            //Show the shopping cart
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let vc = storyboard.instantiateViewController(withIdentifier: "cartViewController") as! CartViewController
//                            
//                            self.present(vc, animated: true) {
//                                
//                                //self.navigationController?.popToRootViewControllerAnimated(false)
//                                let vc = self.navigationController?.viewControllers[1]
//                                self.navigationController?.popToViewController(vc!, animated: true)
//                            }
//                            
//                        }catch {
//                            "Error saving tempItem: \(error)"
//                        }
//                    }
//                }
//            }
//        }
//        
//        
//        
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.fabricNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return self.changePickerViewFontSize(self.fabricNames[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = self.fabricNames[row]
        return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //updated the category in shopping cart
        self.delegate.didGetFabric(self.fabricNames[row])
    }
    
}


