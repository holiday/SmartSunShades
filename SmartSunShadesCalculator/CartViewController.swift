//
//  CartViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 5/15/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, ColorViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let shoppingCartController = ShoppingCartController.sharedInstance
    var isKeyboardVisible:Bool = false
    var indexPathToDelete:NSIndexPath?
    var estimatedDelivery:String?
    
    @IBOutlet weak var totalDiscountsField: UILabel!
    @IBOutlet weak var subTotalField: UILabel!
    @IBOutlet weak var discountedTotal:UILabel!
    @IBOutlet weak var enterDiscountField: UITextField!
    @IBOutlet weak var totalSqInchesField:UILabel!
    @IBOutlet weak var fiftyPercentOffField:UILabel!
    @IBOutlet weak var datePickerView:UIView!
    @IBOutlet weak var datePicker:UIDatePicker!
    @IBOutlet weak var dateTextField:UITextField!
    
    override func viewDidLoad() {
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CartViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.enterDiscountField.delegate = self
        
        self.dateTextField.delegate = self
        self.datePickerView.hidden = true
        self.datePicker.date = NSDate()
        self.datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        self.datePicker.addTarget(self, action: #selector(CartViewController.didSelectDate), forControlEvents: .ValueChanged)
        
        
        let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cartTableViewCell")
    }
    
    func didSelectDate(datepicker:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        self.dateTextField.text = strDate
        self.estimatedDelivery = strDate
    }
    
    func dismissKeyboard() {
        
        if self.isKeyboardVisible {
            self.textFieldShouldReturn(self.enterDiscountField)
            view.endEditing(true)
        }
        
        if self.datePickerView.hidden == false {
            dispatch_async(dispatch_get_main_queue(), {
                self.datePickerView.hidden = true
            })
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == self.dateTextField {
            self.textFieldShouldReturn(self.dateTextField)
            dispatch_async(dispatch_get_main_queue(), {
                self.datePickerView.hidden = false
            })
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.view.frame.origin.y -= 150
        }
        
        isKeyboardVisible = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == self.dateTextField {
            self.dateTextField.resignFirstResponder()
            return false
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.view.frame.origin.y += 150
        }
        
        enterDiscountField.resignFirstResponder()
        
        self.handleEnteredDiscount()
        
        isKeyboardVisible = false
        
        return false
    }
    
    func handleEnteredDiscount() {
        
        let enteredDiscountValue = Double(enterDiscountField.text!)
        
        if enteredDiscountValue != nil {
            self.setDiscount(enteredDiscountValue!)
        }else if (enterDiscountField.text == "") {
            return
        }else{
            let alert:UIAlertView = UIAlertView(title: "You have entered an invalid discount amount", message: "Please enter a discount between 1-100 (do not include % symbol)", delegate: self, cancelButtonTitle: "Try Again")
            
            dispatch_async(dispatch_get_main_queue(), { 
                alert.show()
            })
            self.enterDiscountField.text = ""
        }
    }
    
    func updateDiscount() {
        
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if cart.subTotal!.intValue > 0 {
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.totalDiscountsField.text = "-$\(cart.getDiscountedTotal())"
                        self.subTotalField.text = "$\(cart.subTotal!)"
                        self.discountedTotal.text = "$\(cart.getTotal())"
                    })
                }
            }
        }
    }
    
    func setDiscount(discount:Double) {
        
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                cart.discountPercent = discount
                self.updateDiscount()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                subTotalField.text = "$\(cart.getDiscountedTotal())"
                self.discountedTotal.text = "$\(cart.getTotal())"
                self.enterDiscountField.text = "\(cart.discountPercent!)"
                let roundedSqft = Double(round(self.shoppingCartController.getTotalSqFootage()!*1000)/1000)
                self.totalSqInchesField.text = "Total Sq Footage: \(roundedSqft)"
                self.fiftyPercentOffField.text = "-$\(cart.getFiftyOff())"
                self.updateDiscount()
            }
        }
        
        
    }
    
    @IBAction func didPressEmailQuote(sender: AnyObject) {
        
        
        
        if let customer = DataController.sharedInstance.customer {
            
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients(["innovativewc@gmail.com", "smartsunshades@gmail.com"])
            
            mailComposerVC.setSubject("Quote for \(customer.email!)")
            
            var htmlTable = ""
            var alert:UIAlertView
            
            if let cart:Cart = customer.cart as? Cart {
                
                if let items:NSOrderedSet = cart.items {
                    
                    let itemsArray = Array(items)
                    
                    for item in itemsArray {
                        htmlTable += (item as! Item).getHTMLTableString()
                    }
                    
                    var customerFirstName = customer.firstName
                    var customerLastName = customer.lastName
                    
                    if customerFirstName == nil || customerFirstName == "" {
                        customerFirstName = "Valued"
                        customerLastName = "Customer"
                    }
                    
                    if self.estimatedDelivery == nil {
                        self.estimatedDelivery = "N/A"
                    }
                    
                    htmlTable = "Dear \(customerFirstName!) \(customerLastName!),<br/><br/>" +
                        "Email: \(customer.email!) <br/>" +
                        "Address: \(customer.address!) <br/>" +
                        "Phone: \(customer.phoneNumber!) <br/>" +
                        
                        "Expected delivery: \(self.estimatedDelivery!) <br/><br/>" +
                        
                        "Here the quote you requested. <br/><br/>" +
                        "<table border=\"1\"><col width=\"100\"><thead><tr><th>Category</th><th>Location</th><th>Width</th><th>Height</th><th>Color</th><th>Fabric</th><th>Quantity</th></tr></thead>\(htmlTable)</table><br/>" +
                        "Total Quantity: \(cart.items!.count)<br/>" +
                        "Sub-Total: $\(cart.subTotal!)<br/>" +
                        "50% Discount: -\(cart.getFiftyOff())<br/>" +
                        "Additional Discount (%): \(cart.discountPercent!)%<br/>" +
                        "Total Discounts: $\(cart.getDiscountedTotal())<br/>" +
                        "Total: $\(cart.getTotal()) <br/></br/>" +
                        
                        "Thank you, <br/> SmartSunShades"
                    
                    mailComposerVC.setMessageBody(htmlTable, isHTML: true)
                    
                    if MFMailComposeViewController.canSendMail() {
                        self.presentViewController(mailComposerVC, animated: true, completion: nil)
                    } else {
                        alert = UIAlertView(title: "Mail not setup", message: "It appears your mail app is not setup to send emails. Please add your email address into the mail app and try this again.", delegate: nil, cancelButtonTitle: "Done")
                        alert.show()
                    }
                    
                }else{
                    print("No items in this customer's cart")
                    alert = UIAlertView(title: "No items in cart", message: "Please add items in the cart first", delegate: nil, cancelButtonTitle: "Done")
                    alert.show()
                    return
                }
                
            }else{
                print("Failed to load customer cart")
            }
            
            
            
        }else{
            print("Error: Failed to retrieve customer information")
        }
    }
    
    @IBAction func didPressAddMoreItems(sender: AnyObject) {
        
        self.didPressHide(self)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        print(error?.description)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressHide(sender: AnyObject) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let customer = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if let items:NSOrderedSet = cart.items {
                    if items.count <= 0 {
                        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {
                            let alert = UIAlertView(title: "Cart Empty", message: "There are no items in the shopping cart to display", delegate: self, cancelButtonTitle: "ok")
                            
                            alert.show()
                        })
                    }else{
                        return items.count
                    }
                }
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CartTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cartTableViewCell") as! CartTableViewCell
        
        if let customer = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if let items:NSOrderedSet = cart.items {
                    let itemsArray:NSArray = Array(items)
                    cell.populateTableCell(itemsArray[indexPath.row] as! Item)
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:CartTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! CartTableViewCell
        
        cell.contentView.backgroundColor = UIColor(red: 28.0/255, green: 85.0/255, blue: 121.0/255, alpha: 1.0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:CartTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! CartTableViewCell
        
        cell.contentView.backgroundColor = UIColor(red: 31.0/255, green: 96.0/255, blue: 137.0/255, alpha: 1.0)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func didSelectColor(color: String, indexPath: NSIndexPath) {
        
        if let customer = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if let items:NSOrderedSet = cart.items {
                    let itemsArray:NSArray = Array(items)
                    let item:Item = itemsArray[indexPath.row] as! Item
                    item.color = color
                    do {
                        try DataController.sharedInstance.managedObjectContext?.save()
                        self.tableView.reloadData()
                    }catch {
                        print("Error: Failed to save color: \(error)")
                    }
                    
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let color = UITableViewRowAction(style: .Normal, title: "Color") { (action, indexPath) in
            //Show color picker controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let colorVc = storyboard.instantiateViewControllerWithIdentifier("colorViewController") as! ColorViewController
            colorVc.delegate = self
            colorVc.indexPath = indexPath
            self.presentViewController(colorVc, animated: true, completion: nil)
            
        }
        
        color.backgroundColor = UIColor.blueColor()
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { (action, indexPath) in
            
            self.indexPathToDelete = indexPath
            
            let alert = UIAlertView(title: "Delete item", message: "Are you sure you want to delete this item?", delegate: self, cancelButtonTitle: "cancel", otherButtonTitles: "delete")
            
            alert.show()
        }
        
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, color]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if self.indexPathToDelete == nil {
            return
        }
        
        if alertView.title == "Delete item" {
            if buttonIndex == 1 {
                
                //Delete item
                if let customer = DataController.sharedInstance.customer {
                    if let cart:Cart = customer.cart as? Cart {
                        if let items:NSOrderedSet = cart.items {
                            let itemsArray:NSArray = Array(items)
                            let item:Item = itemsArray[self.indexPathToDelete!.row] as! Item
                            
                            DataController.sharedInstance.managedObjectContext?.deleteObject(item)
                            do {
                                try DataController.sharedInstance.managedObjectContext?.save()
                                self.tableView.reloadData()
                                self.updateDiscount()
                            }catch {
                                print("Error deleting item from cart: \(error)")
                            }
                            
                        }
                    }
                }
                
            }
        }
    }

}
