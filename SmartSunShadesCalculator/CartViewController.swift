//
//  CartViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 5/15/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import MessageUI

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let shoppingCartController = ShoppingCartController.sharedInstance
    let shoppingCart:ShoppingCart = ShoppingCartController.sharedInstance.shoppingCart
    var isKeyboardVisible:Bool = false
    
    @IBOutlet weak var totalDiscountsField: UILabel!
    @IBOutlet weak var subTotalField: UILabel!
    @IBOutlet weak var discountedTotal:UILabel!
    @IBOutlet weak var enterDiscountField: UITextField!
    @IBOutlet weak var totalSqftField:UILabel!
    
    override func viewDidLoad() {
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CartViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.enterDiscountField.delegate = self
        
        let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cartTableViewCell")
    }
    
    
    
    func dismissKeyboard() {
        
        if self.isKeyboardVisible {
            self.textFieldShouldReturn(self.enterDiscountField)
            view.endEditing(true)
        }
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        dispatch_async(dispatch_get_main_queue()) { 
            self.view.frame.origin.y -= 150
        }
        
        isKeyboardVisible = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
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
        if self.shoppingCart.subTotal > 0 {
            self.totalDiscountsField.text = "-$\(self.shoppingCart.getTotalSaved())"
            self.subTotalField.text = "$\(self.shoppingCart.subTotal)"
            self.discountedTotal.text = "$\(self.shoppingCart.getDiscountedTotal())"
        }
    }
    
    func setDiscount(discount:Double) {
        self.shoppingCart.discountPercent = discount
        self.updateDiscount()
    }
    
    override func viewWillAppear(animated: Bool) {
        subTotalField.text = "$\(self.shoppingCart.getDiscountedTotal())"
        self.discountedTotal.text = "$\(self.shoppingCart.getDiscountedTotal())"
        self.enterDiscountField.text = "\(self.shoppingCart.discountPercent)"
        let roundedSqft = Double(round(self.shoppingCart.getTotalSqft()*1000)/1000)
        self.totalSqftField.text = "Total Sqft: \(roundedSqft)"
        self.updateDiscount()
    }
    
    @IBAction func didPressEmailQuote(sender: AnyObject) {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        if self.shoppingCartController.customer.email != nil {
            mailComposerVC.setToRecipients([self.shoppingCartController.customer.email!])
        }
        mailComposerVC.setSubject("Quote")
        
        var htmlTable = ""
        var alert:UIAlertView
        
        //Check if the cart is empty
        if self.shoppingCart.cartItems.count <= 0 {
            alert = UIAlertView(title: "No items in cart", message: "Please add items in the cart first", delegate: nil, cancelButtonTitle: "Done")
            alert.show()
            return
        }
        
        for item in self.shoppingCart.cartItems {
            htmlTable += item.getHTMLTableString()
        }
        
        var customerFirstName = self.shoppingCartController.customer.firstName
        var customerLastName = self.shoppingCartController.customer.lastName
        
        if customerFirstName == nil || customerFirstName == "" {
            customerFirstName = "Valued"
            customerLastName = "Customer"
        }
        
        htmlTable = "Dear \(customerFirstName!) \(customerLastName!),<br/><br/> Here the quote you requested. <br/><br/> <table border=\"1\"><col width=\"100\"><thead><tr><th>Category</th><th>Location</th><th>Width</th><th>Height</th><th>Quantity</th></tr></thead>\(htmlTable)</table><br/>Total-Discounts: $\(self.shoppingCart.getTotalSaved())<br/>Sub-Total: $\(self.shoppingCart.subTotal)<br/>Total: $\(self.shoppingCart.getDiscountedTotal())"
        
        mailComposerVC.setMessageBody(htmlTable, isHTML: true)
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposerVC, animated: true, completion: nil)
        } else {
            alert = UIAlertView(title: "Mail not setup", message: "It appears your mail app is not setup to send emails. Please add your email address into the mail app and try this again.", delegate: nil, cancelButtonTitle: "Done")
            alert.show()
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
        return self.shoppingCart.cartItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CartTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cartTableViewCell") as! CartTableViewCell
        
        cell.populateTableCell(self.shoppingCart.cartItems[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }

}
