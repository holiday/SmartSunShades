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

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, ColorViewControllerDelegate, ShoppingCartControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let shoppingCartController = ShoppingCartController.sharedInstance
    var isKeyboardVisible:Bool = false
    var indexPathToDelete:NSIndexPath?
    var indexPathToEdit:NSIndexPath?
    var didMoveUpScreen:Bool = false
    
    static var estimatedDeliveryDate:NSDate = NSDate()
    static var estimatedDelivery:String?
    
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var depositField: UITextField!
    @IBOutlet weak var taxField: UITextField!
    @IBOutlet weak var totalDiscountsField: UILabel!
    @IBOutlet weak var subTotalField: UILabel!
    @IBOutlet weak var discountedTotal:UILabel!
    @IBOutlet weak var enterDiscountField: UITextField!
    @IBOutlet weak var totalSqInchesField:UILabel!
    @IBOutlet weak var fiftyPercentOffField:UILabel!
    @IBOutlet weak var datePickerView:UIView!
    @IBOutlet weak var datePicker:UIDatePicker!
    @IBOutlet weak var dateTextField:UITextField!
    @IBOutlet weak var balanceField:UILabel!
    
    override func viewDidLoad() {
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CartViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.enterDiscountField.delegate = self
        self.taxField.delegate = self
        self.depositField.delegate = self
        self.commentField.delegate = self
        
        self.dateTextField.delegate = self
        self.datePickerView.hidden = true
        self.datePicker.date = NSDate()
        self.datePicker.setValue(UIColor.blackColor(), forKeyPath: "textColor")
        self.datePicker.addTarget(self, action: #selector(CartViewController.didSelectDate), forControlEvents: .ValueChanged)
        
        
        CartViewController.estimatedDeliveryDate = NSDate()
        self.updateEstimatedDeliveryDate(CartViewController.estimatedDeliveryDate)
        
        
        let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cartTableViewCell")
    }
    
    func didSelectDate(datepicker:UIDatePicker) {
        CartViewController.estimatedDeliveryDate = datepicker.date
        self.updateEstimatedDeliveryDate(datepicker.date)
    }
    
    func updateEstimatedDeliveryDate(date:NSDate) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        let strDate = dateFormatter.stringFromDate(date)
        self.dateTextField.text = strDate
        CartViewController.estimatedDelivery = strDate
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
        
        self.textViewShouldEndEditing(self.commentField)
    }
    
    func moveUpScreen() {
        dispatch_async(dispatch_get_main_queue()) {
            if self.didMoveUpScreen == false {
                self.view.frame.origin.y -= 250
                self.didMoveUpScreen = true
            }
        }
    }
    
    func moveDownScreen() {
        dispatch_async(dispatch_get_main_queue()) {
            if self.didMoveUpScreen == true {
                self.didMoveUpScreen = false
                self.view.frame.origin.y += 250
            }
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.moveUpScreen()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.moveDownScreen()
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        self.commentField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == self.dateTextField {
            self.textFieldShouldReturn(self.dateTextField)
            dispatch_async(dispatch_get_main_queue(), {
                self.datePickerView.hidden = false
            })
            return
        }
        
        self.moveUpScreen()
        
        isKeyboardVisible = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == self.dateTextField {
            self.dateTextField.resignFirstResponder()
            return false
        }
        
        self.moveDownScreen()
        
        enterDiscountField.resignFirstResponder()
        taxField.resignFirstResponder()
        depositField.resignFirstResponder()
        
        self.handleEnteredDiscount()
        if let tax = Double(self.taxField.text!) {
            self.setTax(tax)
        }
        
        if let deposit = Double(self.depositField.text!) {
            self.setDepositAmount(deposit)
        }
        
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
    
    func updateCart() {
        
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if cart.subTotal!.intValue > 0 {
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.totalDiscountsField.text = "-$\(cart.getRoundedDecimal(cart.getDiscountedTotal()))"
                        self.subTotalField.text = "$\(cart.getRoundedDecimal(cart.subTotal!.doubleValue))"
                        self.discountedTotal.text = "$\(cart.getRoundedDecimal(cart.getTotal()))"
                        self.balanceField.text = "$\(cart.getRoundedDecimal(cart.getBalance()))"
                    })
                }
            }
        }
    }
    
    func setDepositAmount(deposit:Double) {
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                cart.deposit = deposit
                DataController.sharedInstance.save()
                self.updateCart()
            }
        }
    }
    
    func setTax(tax:Double) {
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                cart.tax = tax
                DataController.sharedInstance.save()
                self.updateCart()
            }
        }
    }
    
    func setComments(comment:String) {
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                cart.comments = comment
                DataController.sharedInstance.save()
            }
        }
    }
    
    func setDiscount(discount:Double) {
        
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                cart.discountPercent = discount
                DataController.sharedInstance.save()
                self.updateCart()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                self.commentField.text = "\(cart.comments!)"
                self.subTotalField.text = "$\(cart.getRoundedDecimal(cart.getDiscountedTotal()))"
                self.taxField.text = "\(cart.tax!)"
                self.depositField.text = "\(cart.deposit!)"
                self.discountedTotal.text = "$\(cart.getRoundedDecimal(cart.getTotal()))"
                self.enterDiscountField.text = "\(cart.discountPercent!)"
                let roundedSqft = cart.getRoundedDecimal(self.shoppingCartController.getTotalSqFootage()!)
                self.totalSqInchesField.text = "Total Sq Footage: \(roundedSqft)"
                self.fiftyPercentOffField.text = "-$\(cart.getRoundedDecimal(cart.getFiftyOff()))"
                self.updateCart()
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
                
                self.setComments(self.commentField.text)
                
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
                    
                    if CartViewController.estimatedDelivery == nil {
                        CartViewController.estimatedDelivery = "N/A"
                    }
                    
                    htmlTable = "Dear \(customerFirstName!) \(customerLastName!),<br/><br/>" +
                        "Email: \(customer.email!) <br/>" +
                        "Address: \(customer.address!) <br/>" +
                        "Phone: \(customer.phoneNumber!) <br/>" +
                        
                        "Expected delivery: \(CartViewController.estimatedDelivery!) <br/><br/>" +
                        
                        "Here the quote you requested. <br/><br/>" +
                        "<table border=\"1\"><col width=\"100\"><thead><tr><th>Category</th><th>Location</th><th>Width</th><th>Height</th><th>Quantity</th><th>Color</th><th>Fabric</th></tr></thead>\(htmlTable)</table><br/>" +
                        "Total Square Footage: \(cart.getTotalSquareFootage())<br/>" +
                        "Total Quantity: \(cart.getTotalQuantity())<br/>" +
                        "Sub-Total: $\(cart.subTotal!)<br/>" +
                        "50% Discount: -\(cart.getFiftyOff())<br/>" +
                        "Additional Discount (%): \(cart.discountPercent!)%<br/>" +
                        "You Saved: $\(cart.getDiscountedTotal())<br/>" +
                        "Taxes (%): \(cart.tax!)% <br/>" +
                        "Final Total: $\(cart.getTotal()) <br/>" +
                        "Deposit: $\(cart.deposit!) <br/>" +
                        "Balance: $\(cart.getBalance())</br/></br/>" +
                        
                        "Comments: \(cart.comments!) <br/><br/>" +
                        
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
        
        self.setComments(self.commentField.text)
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
        return 170
    }
    
    func getItemAtIndexPath(indexPath:NSIndexPath) -> Item? {
        if let customer = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if let items:NSOrderedSet = cart.items {
                    let itemsArray:NSArray = Array(items)
                    let item:Item = itemsArray[indexPath.row] as! Item
                    return item
                    
                }
            }
        }
        
        return nil
    }
    
    func updateItemPrice(item:Item) {
        let pt = PriceTable(fileName: item.groupFileName!, fileExtension: "csv")
        
        let price = pt.getPrice(Double(item.itemWidth!), widthFineInchIndex: item.getWidthFineInch().index, height: Double(item.itemHeight!), heightFineInchIndex: item.getHeightFineInch().index)
        
        item.calculateSqFootage()
        
        item.price = Double(item.quantity!) * price
        
        self.updateCart()
    }
    
    func didSelectColor(color: String, indexPath: NSIndexPath) {
        
        if let item = self.getItemAtIndexPath(indexPath) {
            item.color = color
            DataController.sharedInstance.save()
            self.tableView.reloadData()
        }
    }
    
    func didGetLocation(location: String) {
        if let indexPath = self.indexPathToEdit {
            if let item = self.getItemAtIndexPath(indexPath) {
                item.location = location
                DataController.sharedInstance.save()
                self.tableView.reloadData()
            }
        }
    }
    
    func didGetWidthData(itemWidth: Double, itemWidthIndex: Int) {
        
        if let indexPath = self.indexPathToEdit {
            if let item = self.getItemAtIndexPath(indexPath) {
                
                item.itemWidth = itemWidth
                item.itemWidthFineInchIndex = itemWidthIndex
                
                self.updateItemPrice(item)
                
                DataController.sharedInstance.save()
                self.tableView.reloadData()
            }
        }
    }
    
    func didGetHeightData(itemHeight: Double, itemHeightIndex: Int) {
        
        if let indexPath = self.indexPathToEdit {
            if let item = self.getItemAtIndexPath(indexPath) {
                item.itemHeight = itemHeight
                item.itemHeightFineInchIndex = itemHeightIndex
                
                self.updateItemPrice(item)
                
                DataController.sharedInstance.save()
                self.tableView.reloadData()
            }
        }
    }
    
    func didGetQuantity(quantity: Int) {
        if let indexPath = self.indexPathToEdit {
            if let item = self.getItemAtIndexPath(indexPath) {
                item.quantity = quantity
                
                self.updateItemPrice(item)
                
                DataController.sharedInstance.save()
                self.tableView.reloadData()
            }
        }
    }
    
    func didGetFabric(fabric: String) {
        if let indexPath = self.indexPathToEdit {
            if let item = self.getItemAtIndexPath(indexPath) {
                item.fabricName = fabric
                
                DataController.sharedInstance.save()
                self.tableView.reloadData()
            }
        }
    }
    
    func didGetCategory(groupName: String, groupFileName: String) {
        if let indexPath = self.indexPathToEdit {
            if let item = self.getItemAtIndexPath(indexPath) {
                
                let cell:CartTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! CartTableViewCell
                
                dispatch_async(dispatch_get_main_queue(), { 
                    cell.groupName.text = groupName
                })
                
                item.groupName = groupName
                item.groupFileName = groupFileName
                
                self.updateItemPrice(item)
                
                DataController.sharedInstance.save()
                self.tableView.reloadData()
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
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { (action, indexPath) in
            
            self.indexPathToDelete = indexPath
            
            let alert = UIAlertView(title: "Delete item", message: "Are you sure you want to delete this item?", delegate: self, cancelButtonTitle: "cancel", otherButtonTitles: "delete")
            
            alert.show()
        }
        
        let location = UITableViewRowAction(style: .Normal, title: "Location") { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let locationVC = storyboard.instantiateViewControllerWithIdentifier("locationViewController") as! LocationViewController
            self.indexPathToEdit = indexPath
            locationVC.delegate = self
            self.presentViewController(locationVC, animated: true, completion: nil)
        }
        
        
        let width = UITableViewRowAction(style: .Normal, title: "Width") { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let widthVC = storyboard.instantiateViewControllerWithIdentifier("widthViewController") as! WidthViewController
            self.indexPathToEdit = indexPath
            widthVC.delegate = self
            self.presentViewController(widthVC, animated: true, completion: nil)
        }
        
        let height = UITableViewRowAction(style: .Normal, title: "Height") { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let heightVC = storyboard.instantiateViewControllerWithIdentifier("heightViewController") as! HeightViewController
            self.indexPathToEdit = indexPath
            heightVC.delegate = self
            self.presentViewController(heightVC, animated: true, completion: nil)
        }
        
        let quantity = UITableViewRowAction(style: .Normal, title: "Qty") { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let qtyVC = storyboard.instantiateViewControllerWithIdentifier("quantityViewController") as! QuantityViewController
            self.indexPathToEdit = indexPath
            qtyVC.delegate = self
            self.presentViewController(qtyVC, animated: true, completion: nil)
        }
        
        let category = UITableViewRowAction(style: .Normal, title: "Category") { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let categoryVC = storyboard.instantiateViewControllerWithIdentifier("categoryViewController") as! CategoryViewController
            self.indexPathToEdit = indexPath
            categoryVC.delegate = self
            self.presentViewController(categoryVC, animated: true, completion: nil)
        }
        
        let fabric = UITableViewRowAction(style: .Normal, title: "Fabric") { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let fabricVC = storyboard.instantiateViewControllerWithIdentifier("fabricViewController") as! FabricViewController
            self.indexPathToEdit = indexPath
            fabricVC.delegate = self
            self.presentViewController(fabricVC, animated: true, completion: nil)
        }
        
        delete.backgroundColor = UIColor.redColor()
        color.backgroundColor = UIColor(red: 147.0/255, green: 193.0/255, blue: 149.0/255, alpha: 1)
        location.backgroundColor = UIColor(red: 88.0/255, green: 193.0/255, blue: 91.0/255, alpha: 1)
        width.backgroundColor = UIColor(red: 147.0/255, green: 193.0/255, blue: 149.0/255, alpha: 1)
        height.backgroundColor = UIColor(red: 88.0/255, green: 193.0/255, blue: 91.0/255, alpha: 1)
        quantity.backgroundColor = UIColor(red: 147.0/255, green: 193.0/255, blue: 149.0/255, alpha: 1)
        category.backgroundColor = UIColor(red: 88.0/255, green: 193.0/255, blue: 91.0/255, alpha: 1)
        fabric.backgroundColor = UIColor(red: 147.0/255, green: 193.0/255, blue: 149.0/255, alpha: 1)
        
        return [delete, color, location, width, height, quantity, category, fabric]
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
                                self.updateCart()
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
