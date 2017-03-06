//
//  CustomerViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/9/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CustomerViewController: UIViewController, UITextFieldDelegate, CustomersViewControllerDelegate {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField:UITextField!
    
    var currentFocusedTextField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "navBarImage"))
        
        self.firstNameField.delegate = self
        self.lastNameField.delegate = self
        self.addressField.delegate = self
        self.emailField.delegate = self
        self.phoneNumberField.delegate = self
        
        let tap:UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateForm()
    }
    
    @IBAction func didPressLoadCustomers() {
        if let customers = DataController.sharedInstance.loadCustomers() {
            if customers.count > 0 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let customersVC:CustomersViewController = storyboard.instantiateViewController(withIdentifier: "customersViewController") as! CustomersViewController
                customersVC.delegate = self
                self.present(customersVC, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Customers", message: "There are no saved customers at this point.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didSelectCustomer(_ customer: Customers) {
        self.firstNameField.text = customer.firstName
        self.lastNameField.text = customer.lastName
        self.addressField.text = customer.address
        self.phoneNumberField.text = customer.phoneNumber
        self.emailField.text = customer.email
        
        //Store the customer
        DataController.sharedInstance.customer = customer
    }
    
    @IBAction func didPressAddNewCustomer(_ sender:UIButton){
        self.firstNameField.text = ""
        self.lastNameField.text = ""
        self.addressField.text = ""
        self.phoneNumberField.text = ""
        self.emailField.text = ""
    }
    
    @IBAction func didPressNext(_ sender: UIButton) {
        
        self.createNewCustomer()
        
    }
    
    func initializeCustomer() {
        if DataController.sharedInstance.customer == nil {
            self.createNewCustomer()
        }
    }
    
    func updateForm(){
        if let customer = DataController.sharedInstance.customer {
            self.firstNameField.text = customer.firstName
            self.lastNameField.text = customer.lastName
            self.addressField.text = customer.address
            self.phoneNumberField.text = customer.phoneNumber
            self.emailField.text = customer.email
        }
    }
    
    func updateCustomer() {
        if let customer = DataController.sharedInstance.customer {
            customer.firstName = self.firstNameField.text
            customer.lastName = self.lastNameField.text
            customer.address = self.addressField.text
            customer.phoneNumber = self.phoneNumberField.text
            customer.email = self.emailField.text
            customer.updated_at = NSDate()
        }
    }
    
    func validateCustomer() -> Bool {
        if let email = self.emailField.text {
            if email != "" && email.characters.count > 8 && email.range(of: "@") != nil {
                return true
            }
        }
        
        return false
    }
    
    func createNewCustomer() {
        if self.validateCustomer() != false {
            if let customer = DataController.sharedInstance.loadCustomerByEmail(self.emailField.text!) {
                print("Using existing customer")
                self.updateCustomer()
                DataController.sharedInstance.customer = customer
                return
            }
        }else{
            let alert = UIAlertController(title: "Invalid Data", message: "Please ensure that the customer has a valid firstname, lastname, email and phone number", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        if let context = DataController.sharedInstance.managedObjectContext {
            let ent = NSEntityDescription.entity(forEntityName: "Customers", in: context)
            let cartEnt = NSEntityDescription.entity(forEntityName: "Cart", in: context)
            
            if ent != nil {
                let customer = Customers(entity: ent!, insertInto: context)
                let cart = Cart(entity: cartEnt!, insertInto: context)
                
                cart.tax = 0.0
                cart.deposit = 0.0
                cart.subTotal = 0.0
                cart.discountPercent = 0.0
                cart.discountedTotal = 0.0
                
                customer.firstName = self.firstNameField.text!
                customer.lastName = self.lastNameField.text!
                customer.address = self.addressField.text!
                customer.email = self.emailField.text!
                customer.phoneNumber = self.phoneNumberField.text!
                customer.created_at = NSDate()
                customer.updated_at = NSDate()
                customer.cart = cart
                
                do{
                    try context.save()
                    DataController.sharedInstance.customer = customer
                    print("Created customer: \(customer)")
                }catch{
                    print("Error occurred while saving Customer context")
                }
            }else{
                print("Error creating customer")
            }
        }
        
        
    }
    
    func createNewCart(_ customer:Customers) {
        if let context = DataController.sharedInstance.managedObjectContext {
            let ent = NSEntityDescription.entity(forEntityName: "Customers", in: context)
            let cartEnt = NSEntityDescription.entity(forEntityName: "Cart", in: context)
            
            if ent != nil {
                let cart = Cart(entity: cartEnt!, insertInto: context)
                
                cart.subTotal = 0.0
                cart.discountPercent = 0.0
                cart.discountedTotal = 0.0
                customer.cart = cart
                
                do {
                    try context.save()
                }catch{
                    print("Error saving cart to customer: \(error)")
                }
            }
        }
    }
    
    @IBAction func showShoppingCart(_ sender: AnyObject) {
        
        if let customer = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if cart.items?.count > 0 {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "cartViewController") as! CartViewController
                    self.present(vc, animated: true, completion: nil)
                }else{
                    
                    
                    let alert = UIAlertController(title: "Cart Empty", message: "Please add items to your card", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                print("Cart object is nil, creating one for this customer")
                self.createNewCart(customer)
            }
        }
    }
    
    func dismissKeyboard() {
        if self.currentFocusedTextField != nil {
            self.currentFocusedTextField?.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentFocusedTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.emailField.resignFirstResponder()
            
            self.initializeCustomer()
            
            self.performSegue(withIdentifier: "segueToLocation", sender: nil)
            return true
        }
        return false
    }

}
