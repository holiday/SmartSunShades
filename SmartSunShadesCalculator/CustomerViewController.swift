//
//  CustomerViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/9/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class CustomerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    let shoppingCartController = ShoppingCartController.sharedInstance
    
    var currentFocusedTextField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "navBarImage"))
        
        self.firstNameField.delegate = self
        self.lastNameField.delegate = self
        self.addressField.delegate = self
        self.emailField.delegate = self
        
        let tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func didPressNext(sender: UIButton) {
        
        self.initData()
        
    }
    
    func initData() {
        self.shoppingCartController.customer = Customer(firstName: "Rashaad", lastName: "Ramdeen", address: "123 Anywherer", email: "rashaad.ramdeen@gmail.com")
        
        let emptyItem = Item(location: nil, width: nil, height: nil, quantity: nil)
        
        self.shoppingCartController.shoppingCart.addTempItem(emptyItem)
    }
    
    @IBAction func showShoppingCart(sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("cartViewController") as! CartViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func dismissKeyboard() {
        if self.currentFocusedTextField != nil {
            self.currentFocusedTextField?.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentFocusedTextField = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.emailField.resignFirstResponder()
            self.initData()
            
            self.performSegueWithIdentifier("segueToLocation", sender: nil)
            return true
        }
        return false
    }

}
