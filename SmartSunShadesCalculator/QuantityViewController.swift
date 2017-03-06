//
//  QuantityViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/6/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class QuantityViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var quantityPickerView: UIPickerView!
    
    var currentQuantity:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quantityPickerView.delegate = self
        self.quantityPickerView.dataSource = self
    }
    
    @IBAction func didPressAddToCart(_ sender: AnyObject) {
        self.saveQuantityData()
        
        //add the temp item to the shopping cart
        //updated the width in shopping cart
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart{
                if let context = DataController.sharedInstance.managedObjectContext {
                    if let tempItem = ShoppingCartController.sharedInstance.tempItem {
                        context.insert(tempItem)
                        tempItem.cart = cart
                        tempItem.calculateDefaultPrice()
                        do {
                            try context.save()
                            
                            //Cleanup, remove temp item
                            ShoppingCartController.sharedInstance.tempItem = nil
                            ShoppingCartController.sharedInstance.createTempItem()
                            
                            //Show the shopping cart
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "cartViewController") as! CartViewController
                            
                            self.present(vc, animated: true) {
                                
                                //self.navigationController?.popToRootViewControllerAnimated(false)
                                let vc = self.navigationController?.viewControllers[1]
                                self.navigationController?.popToViewController(vc!, animated: true)
                            }
                            
                        }catch {
                            print("Error saving tempItem: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func saveQuantityData() {
        
        //updated the width in shopping cart
        self.delegate.didGetQuantity(self.currentQuantity)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate.didGetQuantity(self.currentQuantity)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return self.changePickerViewFontSize("\(row+1)")
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = "\(row+1)"
        return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.currentQuantity = row+1
        
        self.saveQuantityData()
        
    }
}
    

