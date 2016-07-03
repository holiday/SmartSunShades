//
//  CustomerViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/9/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import CoreData

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
    
    override func viewWillAppear(animated: Bool) {
        self.updateForm()
    }
    
    @IBAction func didPressLoadCustomers() {
        if let customers = DataController.sharedInstance.loadCustomers() {
            if customers.count > 0 {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let customersVC:CustomersViewController = storyboard.instantiateViewControllerWithIdentifier("customersViewController") as! CustomersViewController
                customersVC.delegate = self
                self.presentViewController(customersVC, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Customers", message: "There are no saved customers at this point.", preferredStyle: .Alert)
            
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func didSelectCustomer(customer: Customers) {
        self.firstNameField.text = customer.firstName
        self.lastNameField.text = customer.lastName
        self.addressField.text = customer.address
        self.phoneNumberField.text = customer.phoneNumber
        self.emailField.text = customer.email
    }
    
    @IBAction func didPressNext(sender: UIButton) {
        
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
        }
    }
    
    func createNewCustomer() {
        if self.emailField.text != "" {
            if let customer = DataController.sharedInstance.loadCustomerByEmail(self.emailField.text!) {
                print("Using existing customer")
                self.updateCustomer()
                DataController.sharedInstance.customer = customer
                return
            }
        }
        
        
        if let context = DataController.sharedInstance.managedObjectContext {
            let ent = NSEntityDescription.entityForName("Customers", inManagedObjectContext: context)
            let cartEnt = NSEntityDescription.entityForName("Cart", inManagedObjectContext: context)
            
            if ent != nil {
                let customer = Customers(entity: ent!, insertIntoManagedObjectContext: context)
                let cart = Cart(entity: cartEnt!, insertIntoManagedObjectContext: context)
                
                cart.subTotal = 0.0
                cart.discountPercent = 0.0
                cart.discountedTotal = 0.0
                
                customer.firstName = self.firstNameField.text!
                customer.lastName = self.lastNameField.text!
                customer.address = self.addressField.text!
                customer.email = self.emailField.text!
                customer.phoneNumber = self.phoneNumberField.text!
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
    
    func createNewCart(customer:Customers) {
        if let context = DataController.sharedInstance.managedObjectContext {
            let ent = NSEntityDescription.entityForName("Customers", inManagedObjectContext: context)
            let cartEnt = NSEntityDescription.entityForName("Cart", inManagedObjectContext: context)
            
            if ent != nil {
                let cart = Cart(entity: cartEnt!, insertIntoManagedObjectContext: context)
                
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
    
    @IBAction func showShoppingCart(sender: AnyObject) {
        
        if let customer = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if cart.items?.count > 0 {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier("cartViewController") as! CartViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                }else{
                    
                    
                    let alert = UIAlertController(title: "Cart Empty", message: "Please add items to your card", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(okAction)
                    self.presentViewController(alert, animated: true, completion: nil)
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentFocusedTextField = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.emailField.resignFirstResponder()
            
            self.initializeCustomer()
            
            self.performSegueWithIdentifier("segueToLocation", sender: nil)
            return true
        }
        return false
    }

}
