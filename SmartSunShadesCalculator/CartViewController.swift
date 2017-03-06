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
    var indexPathToDelete:IndexPath?
    var indexPathToEdit:IndexPath?
    var didMoveUpScreen:Bool = false
    
    static var estimatedDeliveryDate:Date = Date()
    static var estimatedDelivery:String?
    
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var colorField: UITextField!
    @IBOutlet weak var fabricField: UITextField!
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
        self.colorField.delegate = self
        self.fabricField.delegate = self
        
        self.dateTextField.delegate = self
        self.datePickerView.isHidden = true
        self.datePicker.date = Date()
        self.datePicker.setValue(UIColor.black, forKeyPath: "textColor")
        self.datePicker.addTarget(self, action: #selector(CartViewController.didSelectDate), for: .valueChanged)
        
        
        CartViewController.estimatedDeliveryDate = Date()
        self.updateEstimatedDeliveryDate(CartViewController.estimatedDeliveryDate)
        
        
        let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        
        self.tableView.register(nib, forCellReuseIdentifier: "cartTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
                
                if let color = (cart.items?.firstObject as! Item).color {
                    self.colorField.text = color
                }
                
                if let fabric = (cart.items?.firstObject as! Item).fabricName {
                    self.fabricField.text = fabric
                }
                
                self.updateCart()
            }
        }
    }
    
    func didSelectDate(_ datepicker:UIDatePicker) {
        CartViewController.estimatedDeliveryDate = datepicker.date
        self.updateEstimatedDeliveryDate(datepicker.date)
    }
    
    func updateEstimatedDeliveryDate(_ date:Date) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        let strDate = dateFormatter.string(from: date)
        self.dateTextField.text = strDate
        CartViewController.estimatedDelivery = strDate
    }
    
    func dismissKeyboard() {
        
        if self.isKeyboardVisible {
            self.textFieldShouldReturn(self.enterDiscountField)
            view.endEditing(true)
        }
        
        if self.datePickerView.isHidden == false {
            DispatchQueue.main.async(execute: {
                self.datePickerView.isHidden = true
            })
        }
        
        self.textViewShouldEndEditing(self.commentField)
    }
    
    func moveUpScreen() {
        DispatchQueue.main.async {
            if self.didMoveUpScreen == false {
                self.view.frame.origin.y -= 250
                self.didMoveUpScreen = true
            }
        }
    }
    
    func moveDownScreen() {
        DispatchQueue.main.async {
            if self.didMoveUpScreen == true {
                self.didMoveUpScreen = false
                self.view.frame.origin.y += 250
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.moveUpScreen()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.moveDownScreen()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.commentField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.dateTextField {
            self.textFieldShouldReturn(self.dateTextField)
            DispatchQueue.main.async(execute: {
                self.datePickerView.isHidden = false
            })
            return
        }
        
        self.moveUpScreen()
        
        isKeyboardVisible = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.dateTextField {
            self.dateTextField.resignFirstResponder()
            return false
        }
        
        self.moveDownScreen()
        
        enterDiscountField.resignFirstResponder()
        taxField.resignFirstResponder()
        depositField.resignFirstResponder()
        colorField.resignFirstResponder()
        fabricField.resignFirstResponder()
        
        self.handleEnteredDiscount()
        if let tax = Double(self.taxField.text!) {
            self.setTax(tax)
        }else{
            self.taxField.text = "0"
            self.setTax(0)
        }
        
        if let deposit = Double(self.depositField.text!) {
            self.setDepositAmount(deposit)
        }
        
        isKeyboardVisible = false
        
        return false
    }
    
    func handleEnteredDiscount() {
        
        if let enteredDiscountValue = Double(enterDiscountField.text!) {
            if Int(enteredDiscountValue) > 0 && Int(enteredDiscountValue) < 100 {
                self.setDiscount(enteredDiscountValue)
                return
            }
        }
        
        self.enterDiscountField.text = "0"
        self.setDiscount(0)
    }
    
    func updateCart() {
        
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if cart.subTotal!.int32Value > 0 {
                    DispatchQueue.main.async(execute: { 
                        self.totalDiscountsField.text = "-$\(cart.getRoundedDecimal(cart.getDiscountedTotal()))"
                        self.subTotalField.text = "$\(cart.getRoundedDecimal(cart.subTotal!.doubleValue))"
                        self.discountedTotal.text = "$\(cart.getRoundedDecimal(cart.getTotal()))"
                        self.balanceField.text = "$\(cart.getRoundedDecimal(cart.getBalance()))"
                    })
                }
            }
        }
    }
    
    func setDepositAmount(_ deposit:Double) {
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                cart.deposit = deposit as NSNumber?
                DataController.sharedInstance.save()
                self.updateCart()
            }
        }
    }
    
    func setTax(_ tax:Double) {
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                cart.tax = tax as NSNumber?
                DataController.sharedInstance.save()
                self.updateCart()
            }
        }
    }
    
    func setComments(_ comment:String) {
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                cart.comments = comment
                DataController.sharedInstance.save()
            }
        }
    }
    
    func setColor(_ color:String) {
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if let items:NSOrderedSet = cart.items {
                    
                    let itemsArray = Array(items)
                    
                    for item in itemsArray {
                        (item as! Item).color = color
                    }
                    
                    DataController.sharedInstance.save()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func setFabric(_ fabric:String) {
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if let items:NSOrderedSet = cart.items {
                    
                    let itemsArray = Array(items)
                    
                    for item in itemsArray {
                        (item as! Item).fabricName = fabric
                    }
                    
                    DataController.sharedInstance.save()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func setDiscount(_ discount:Double) {
        
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                cart.discountPercent = discount as NSNumber?
                DataController.sharedInstance.save()
                self.updateCart()
            }
        }
    }
    
    @IBAction func didPressEmailQuote(_ sender: AnyObject) {
        
        if let customer = DataController.sharedInstance.customer {
            
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients(["innovativewchd@gmail.com", "smartsunshades@gmail.com"])
            
            mailComposerVC.setSubject("Quote for \(customer.email!)")
            
            var htmlTable = ""
            var alert:UIAlertView
            
            if let cart:Cart = customer.cart as? Cart {
                
                self.setComments(self.commentField.text)
                
                if self.colorField.text != "" {
                    self.setColor(self.colorField.text!)
                }else{
                    let alertController = UIAlertController(title: "Enter a Color", message: "Please enter a valid color", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                if self.fabricField.text != "" {
                    self.setFabric(self.fabricField.text!)
                }else{
                    let alertController = UIAlertController(title: "Enter a Fabric", message: "Please enter a valid fabric", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
                    
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                
                
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
                        self.present(mailComposerVC, animated: true, completion: nil)
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
    
    @IBAction func didPressAddMoreItems(_ sender: AnyObject) {
        
        self.didPressHide(self)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        print(error?.description)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressHide(_ sender: AnyObject) {
        
        self.setComments(self.commentField.text)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let customer = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if let items:NSOrderedSet = cart.items {
                    if items.count <= 0 {
                        self.presentingViewController?.dismiss(animated: true, completion: {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CartTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cartTableViewCell") as! CartTableViewCell
        
        if let customer = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if let items:NSOrderedSet = cart.items {
                    let itemsArray:NSArray = Array(items) as NSArray
                    cell.populateTableCell(itemsArray[indexPath.row] as! Item)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell:CartTableViewCell = tableView.cellForRow(at: indexPath) as! CartTableViewCell
        
        cell.contentView.backgroundColor = UIColor(red: 28.0/255, green: 85.0/255, blue: 121.0/255, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:CartTableViewCell = tableView.cellForRow(at: indexPath) as! CartTableViewCell
        
        cell.contentView.backgroundColor = UIColor(red: 31.0/255, green: 96.0/255, blue: 137.0/255, alpha: 1.0)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func getItemAtIndexPath(_ indexPath:IndexPath) -> Item? {
        if let customer = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if let items:NSOrderedSet = cart.items {
                    let itemsArray:NSArray = Array(items) as NSArray
                    let item:Item = itemsArray[indexPath.row] as! Item
                    return item
                    
                }
            }
        }
        
        return nil
    }
    
    func updateItemPrice(_ item:Item) {
        let pt = PriceTable(fileName: item.groupFileName!, fileExtension: "csv")
        
        let price = pt.getPrice(Double(item.itemWidth!), widthFineInchIndex: item.getWidthFineInch().index, height: Double(item.itemHeight!), heightFineInchIndex: item.getHeightFineInch().index)
        
        item.calculateSqFootage()
        
        item.price = CGFloat(Double(item.quantity!) * price) as NSNumber?
        
        self.updateCart()
    }
    
    func didSelectColor(_ color: String, indexPath: IndexPath) {
        
        if let item = self.getItemAtIndexPath(indexPath) {
            item.color = color
            DataController.sharedInstance.save()
            self.tableView.reloadData()
        }
    }
    
    func didGetLocation(_ location: String) {
        if let indexPath = self.indexPathToEdit {
            if let item = self.getItemAtIndexPath(indexPath) {
                item.location = location
                DataController.sharedInstance.save()
                self.tableView.reloadData()
            }
        }
    }
    
    func didGetWidthData(_ itemWidth: Double, itemWidthIndex: Int) {
        
        if let indexPath = self.indexPathToEdit {
            if let item = self.getItemAtIndexPath(indexPath) {
                
                item.itemWidth = itemWidth as NSNumber?
                item.itemWidthFineInchIndex = itemWidthIndex as NSNumber?
                
                self.updateItemPrice(item)
                
                DataController.sharedInstance.save()
                self.tableView.reloadData()
            }
        }
    }
    
    func didGetHeightData(_ itemHeight: Double, itemHeightIndex: Int) {
        
        if let indexPath = self.indexPathToEdit {
            if let item = self.getItemAtIndexPath(indexPath) {
                item.itemHeight = itemHeight as NSNumber?
                item.itemHeightFineInchIndex = itemHeightIndex as NSNumber?
                
                self.updateItemPrice(item)
                
                DataController.sharedInstance.save()
                self.tableView.reloadData()
            }
        }
    }
    
    func didGetQuantity(_ quantity: Int) {
        if let indexPath = self.indexPathToEdit {
            if let item = self.getItemAtIndexPath(indexPath) {
                item.quantity = quantity as NSNumber?
                
                self.updateItemPrice(item)
                
                DataController.sharedInstance.save()
                self.tableView.reloadData()
            }
        }
    }
    
    func didGetFabric(_ fabric: String) {
        if let indexPath = self.indexPathToEdit {
            if let item = self.getItemAtIndexPath(indexPath) {
                item.fabricName = fabric
                
                DataController.sharedInstance.save()
                self.tableView.reloadData()
            }
        }
    }
    
    func didGetCategory(_ groupName: String, groupFileName: String) {
        if let indexPath = self.indexPathToEdit {
            if let item = self.getItemAtIndexPath(indexPath) {
                
                let cell:CartTableViewCell = tableView.cellForRow(at: indexPath) as! CartTableViewCell
                
                DispatchQueue.main.async(execute: { 
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
//        let color = UITableViewRowAction(style: .normal, title: "Color") { (action, indexPath) in
//            //Show color picker controller
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            
//            let colorVc = storyboard.instantiateViewController(withIdentifier: "colorViewController") as! ColorViewController
//            colorVc.delegate = self
//            colorVc.indexPath = indexPath
//            self.present(colorVc, animated: true, completion: nil)
//            
//        }
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            
            self.indexPathToDelete = indexPath
            
            let alert = UIAlertView(title: "Delete item", message: "Are you sure you want to delete this item?", delegate: self, cancelButtonTitle: "cancel", otherButtonTitles: "delete")
            
            alert.show()
        }
        
        let location = UITableViewRowAction(style: .normal, title: "Location") { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let locationVC = storyboard.instantiateViewController(withIdentifier: "locationViewController") as! LocationViewController
            self.indexPathToEdit = indexPath
            locationVC.delegate = self
            self.present(locationVC, animated: true, completion: nil)
        }
        
        
        let width = UITableViewRowAction(style: .normal, title: "Width") { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let widthVC = storyboard.instantiateViewController(withIdentifier: "widthViewController") as! WidthViewController
            self.indexPathToEdit = indexPath
            widthVC.delegate = self
            self.present(widthVC, animated: true, completion: nil)
        }
        
        let height = UITableViewRowAction(style: .normal, title: "Height") { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let heightVC = storyboard.instantiateViewController(withIdentifier: "heightViewController") as! HeightViewController
            self.indexPathToEdit = indexPath
            heightVC.delegate = self
            self.present(heightVC, animated: true, completion: nil)
        }
        
        let quantity = UITableViewRowAction(style: .normal, title: "Qty") { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let qtyVC = storyboard.instantiateViewController(withIdentifier: "quantityViewController") as! QuantityViewController
            self.indexPathToEdit = indexPath
            qtyVC.delegate = self
            self.present(qtyVC, animated: true, completion: nil)
        }
//        
//        let category = UITableViewRowAction(style: .normal, title: "Category") { (action, indexPath) in
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            
//            let categoryVC = storyboard.instantiateViewController(withIdentifier: "categoryViewController") as! CategoryViewController
//            self.indexPathToEdit = indexPath
//            categoryVC.delegate = self
//            self.present(categoryVC, animated: true, completion: nil)
//        }
        
//        let fabric = UITableViewRowAction(style: .normal, title: "Fabric") { (action, indexPath) in
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            
//            let fabricVC = storyboard.instantiateViewController(withIdentifier: "fabricViewController") as! FabricViewController
//            self.indexPathToEdit = indexPath
//            fabricVC.delegate = self
//            self.present(fabricVC, animated: true, completion: nil)
//        }
        
        delete.backgroundColor = UIColor.red
//        color.backgroundColor = UIColor(red: 147.0/255, green: 193.0/255, blue: 149.0/255, alpha: 1)
        location.backgroundColor = UIColor(red: 88.0/255, green: 193.0/255, blue: 91.0/255, alpha: 1)
        width.backgroundColor = UIColor(red: 147.0/255, green: 193.0/255, blue: 149.0/255, alpha: 1)
        height.backgroundColor = UIColor(red: 88.0/255, green: 193.0/255, blue: 91.0/255, alpha: 1)
        quantity.backgroundColor = UIColor(red: 147.0/255, green: 193.0/255, blue: 149.0/255, alpha: 1)
//        category.backgroundColor = UIColor(red: 88.0/255, green: 193.0/255, blue: 91.0/255, alpha: 1)
//        fabric.backgroundColor = UIColor(red: 147.0/255, green: 193.0/255, blue: 149.0/255, alpha: 1)
        
        return [delete, location, width, height, quantity]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if self.indexPathToDelete == nil {
            return
        }
        
        if alertView.title == "Delete item" {
            if buttonIndex == 1 {
                
                //Delete item
                if let customer = DataController.sharedInstance.customer {
                    if let cart:Cart = customer.cart as? Cart {
                        if let items:NSOrderedSet = cart.items {
                            let itemsArray:NSArray = Array(items) as NSArray
                            let item:Item = itemsArray[self.indexPathToDelete!.row] as! Item
                            
                            DataController.sharedInstance.managedObjectContext?.delete(item)
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
