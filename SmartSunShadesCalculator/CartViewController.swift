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
    
    var itemsArray:NSArray?
    
    let shoppingCartController = ShoppingCartController.sharedInstance
    var isKeyboardVisible:Bool = false
    var indexPathToDelete:IndexPath?
    var indexPathToEdit:IndexPath?
    var didMoveUpScreen:Bool = false
    
    static var estimatedDeliveryDate:Date = Date()
    static var estimatedDelivery:String?
    
    @IBOutlet weak var footerView:UIView!
    
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var colorField: UITextField!
    @IBOutlet weak var fabricField: UITextField!
    @IBOutlet weak var depositField: UITextField!
    @IBOutlet weak var taxField: UITextField!
    
    @IBOutlet weak var totalDiscountsField1: UILabel!
    @IBOutlet weak var totalDiscountsField2: UILabel!
    @IBOutlet weak var totalDiscountsField3: UILabel!
    @IBOutlet weak var totalDiscountsField4: UILabel!
    
    @IBOutlet weak var subTotalField1: UILabel!
    @IBOutlet weak var subTotalField2: UILabel!
    @IBOutlet weak var subTotalField3: UILabel!
    @IBOutlet weak var subTotalField4: UILabel!
    
    @IBOutlet weak var discountedTotal1:UILabel!
    @IBOutlet weak var discountedTotal2:UILabel!
    @IBOutlet weak var discountedTotal3:UILabel!
    @IBOutlet weak var discountedTotal4:UILabel!
    
    @IBOutlet weak var enterDiscountField: UITextField!
    @IBOutlet weak var totalSqInchesField:UILabel!
    
    @IBOutlet weak var fiftyPercentOffField1:UILabel!
    @IBOutlet weak var fiftyPercentOffField2:UILabel!
    @IBOutlet weak var fiftyPercentOffField3:UILabel!
    @IBOutlet weak var fiftyPercentOffField4:UILabel!
    
    @IBOutlet weak var datePickerView:UIView!
    @IBOutlet weak var datePicker:UIDatePicker!
    @IBOutlet weak var dateTextField:UITextField!
    
    @IBOutlet weak var balanceField1:UILabel!
    @IBOutlet weak var balanceField2:UILabel!
    @IBOutlet weak var balanceField3:UILabel!
    @IBOutlet weak var balanceField4:UILabel!
    
    //Other carts
    var twoInchBlindsCart:Cart?
    var shades3Cart:Cart?
    var vienna100Cart:Cart?
    
    
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
        
        self.reloadCartData()
        
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                
                //Clone the other carts off this cart
                if let context:NSManagedObjectContext = DataController.sharedInstance.managedObjectContext {
                    let ent = NSEntityDescription.entity(forEntityName: "Cart", in: context)
                    self.twoInchBlindsCart = Cart(entity: ent!, insertInto: nil)
                    self.twoInchBlindsCart?.tax = cart.tax
                    self.twoInchBlindsCart?.deposit = cart.deposit
                    self.twoInchBlindsCart?.discountPercent = cart.discountPercent
                    
                    self.shades3Cart = Cart(entity: ent!, insertInto: nil)
                    self.shades3Cart?.tax = cart.tax
                    self.shades3Cart?.deposit = cart.deposit
                    self.shades3Cart?.discountPercent = cart.discountPercent
                    
                    self.vienna100Cart = Cart(entity: ent!, insertInto: nil)
                    self.vienna100Cart?.tax = cart.tax
                    self.vienna100Cart?.deposit = cart.deposit
                    self.vienna100Cart?.discountPercent = cart.discountPercent
                    
                    if cart.items != nil && cart.items!.count > 0 {
                        
                        let ent = NSEntityDescription.entity(forEntityName: "Item", in: context)
                        
                        let tempItems1:NSMutableOrderedSet = NSMutableOrderedSet()
                        let tempItems2:NSMutableOrderedSet = NSMutableOrderedSet()
                        let tempItems3:NSMutableOrderedSet = NSMutableOrderedSet()
                        
                        for item in cart.items! {
                            
                            let tempItem1 = Item(entity: ent!, insertInto: nil)
                            let tempItem2 = Item(entity: ent!, insertInto: nil)
                            let tempItem3 = Item(entity: ent!, insertInto: nil)
                            
                            tempItem1.itemHeight = (item as! Item).itemHeight
                            tempItem1.itemHeightFineInchIndex = (item as! Item).itemHeightFineInchIndex
                            tempItem1.itemWidth = (item as! Item).itemWidth
                            tempItem1.itemWidthFineInchIndex = (item as! Item).itemWidthFineInchIndex
                            tempItem1.location = (item as! Item).location
                            tempItem1.quantity = (item as! Item).quantity
                            tempItems1.add(tempItem1)
                            
                            tempItem1.calculateDefaultPrice(groupFileName: CategoryViewController.categoryFileNames[6], groupName: CategoryViewController.categoryTitles[6])
                            
                            tempItem2.itemHeight = (item as! Item).itemHeight
                            tempItem2.itemHeightFineInchIndex = (item as! Item).itemHeightFineInchIndex
                            tempItem2.itemWidth = (item as! Item).itemWidth
                            tempItem2.itemWidthFineInchIndex = (item as! Item).itemWidthFineInchIndex
                            tempItem2.location = (item as! Item).location
                            tempItem2.quantity = (item as! Item).quantity
                            tempItems2.add(tempItem2)
                            
                            tempItem2.calculateDefaultPrice(groupFileName: CategoryViewController.categoryFileNames[3], groupName: CategoryViewController.categoryTitles[3])
                            
                            tempItem3.itemHeight = (item as! Item).itemHeight
                            tempItem3.itemHeightFineInchIndex = (item as! Item).itemHeightFineInchIndex
                            tempItem3.itemWidth = (item as! Item).itemWidth
                            tempItem3.itemWidthFineInchIndex = (item as! Item).itemWidthFineInchIndex
                            tempItem3.location = (item as! Item).location
                            tempItem3.quantity = (item as! Item).quantity
                            tempItems3.add(tempItem3)
                            
                            tempItem3.calculateDefaultPrice(groupFileName: CategoryViewController.categoryFileNames[5], groupName: CategoryViewController.categoryTitles[5])
                        }
                        
                        self.twoInchBlindsCart?.items = tempItems1
                        self.shades3Cart?.items = tempItems2
                        self.vienna100Cart?.items = tempItems3

                        self.twoInchBlindsCart?.calculateSubtotal()
                        self.shades3Cart?.calculateSubtotal()
                        self.vienna100Cart?.calculateSubtotal()
                    }
                    
                }
                
                self.commentField.text = "\(cart.comments!)"
                
                if let subtotal = self.getAggregateSubtotal() {
                    
                    let subtotalArr = subtotal.components(separatedBy: ",")
                    
                    if subtotalArr.count == 4{
                        self.subTotalField1.text = subtotalArr[0]
                        self.subTotalField2.text = subtotalArr[1]
                        self.subTotalField3.text = subtotalArr[2]
                        self.subTotalField4.text = subtotalArr[3]
                    }
                }
                
                self.taxField.text = "\(cart.tax!)"
                self.depositField.text = "\(cart.deposit!)"
                
                if let discountedTotal = self.getAggregateDiscountedTotal() {
                    
                    let discountedTotalArr = discountedTotal.components(separatedBy: ",")
                    
                    if discountedTotalArr.count == 4{
                        self.discountedTotal1.text = discountedTotalArr[0]
                        self.discountedTotal2.text = discountedTotalArr[1]
                        self.discountedTotal3.text = discountedTotalArr[2]
                        self.discountedTotal4.text = discountedTotalArr[3]
                    }
                }
                
                self.enterDiscountField.text = "\(cart.discountPercent!)"
                let roundedSqft = cart.getRoundedDecimal(self.shoppingCartController.getTotalSqFootage()!)
                self.totalSqInchesField.text = "Total Sq Footage: \(roundedSqft)"

                if let fiftyOff = self.getAggregateFiftyOff() {
                    
                    let fiftyOffArr = fiftyOff.components(separatedBy: ",")
                    
                    if fiftyOffArr.count == 4{
                        self.fiftyPercentOffField1.text = fiftyOffArr[0]
                        self.fiftyPercentOffField2.text = fiftyOffArr[1]
                        self.fiftyPercentOffField3.text = fiftyOffArr[2]
                        self.fiftyPercentOffField4.text = fiftyOffArr[3]
                    }
                }
                
                
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
    
    func reloadCartData() {
        if let customer = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if let items:NSOrderedSet = cart.items {
                    self.itemsArray = Array(items) as NSArray
                }
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
                
                UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.view.frame.origin.y -= 250
                }, completion: { (finished) in
                    self.didMoveUpScreen = true
                })
            }
        }
    }
    
    func moveDownScreen() {
        DispatchQueue.main.async {
            if self.didMoveUpScreen == true {
                
                UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.view.frame.origin.y += 250
                }, completion: { (finished) in
                    self.didMoveUpScreen = false
                })
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
    
    func getAggregateSubtotal() -> String? {
        
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if cart.subTotal!.int32Value > 0 {
                    
                    let twoInchDiscountedTotal = self.twoInchBlindsCart!.getRoundedDecimal(self.twoInchBlindsCart!.calculateSubtotal())
                    let shades3DiscountedTotal = self.shades3Cart!.getRoundedDecimal(self.shades3Cart!.calculateSubtotal())
                    let vienna100DiscountedTotal = self.vienna100Cart!.getRoundedDecimal(self.vienna100Cart!.calculateSubtotal())
        
                    return "$\(cart.getRoundedDecimal(cart.subTotal!.doubleValue)), $\(twoInchDiscountedTotal), $\(shades3DiscountedTotal), $\(vienna100DiscountedTotal)"
                }
            }
        }
        
        return nil
    }
    
    func getAggregateDiscountedTotal() -> String? {
        
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if cart.subTotal!.int32Value > 0 {
                    
                    let twoInchDiscountedTotal = self.twoInchBlindsCart!.getRoundedDecimal(self.twoInchBlindsCart!.getTotal())
                    let shades3DiscountedTotal = self.shades3Cart!.getRoundedDecimal(self.shades3Cart!.getTotal())
                    let vienna100DiscountedTotal = self.vienna100Cart!.getRoundedDecimal(self.vienna100Cart!.getTotal())
                    
                    return "$\(cart.getRoundedDecimal(cart.getTotal())), $\(twoInchDiscountedTotal), $\(shades3DiscountedTotal), $\(vienna100DiscountedTotal)"
                }
            }
        }
        
        return nil
    }
    
    func getAggregateFiftyOff() -> String? {
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if cart.subTotal!.int32Value > 0 {
                    
                    let twoInchFiftyOff = self.twoInchBlindsCart!.getRoundedDecimal(self.twoInchBlindsCart!.getFiftyOff())
                    let shades3FiftyOff = self.shades3Cart!.getRoundedDecimal(self.shades3Cart!.getFiftyOff())
                    let vienna100FiftyOff = self.vienna100Cart!.getRoundedDecimal(self.vienna100Cart!.getFiftyOff())
                    
                    return "$\(cart.getRoundedDecimal(cart.getFiftyOff())), $\(twoInchFiftyOff), $\(shades3FiftyOff), $\(vienna100FiftyOff)"
                }
            }
        }
        
        return nil
    }
    
    func getAggregateTotalDiscounts() -> String? {
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if cart.subTotal!.int32Value > 0 {
                    
                    let twoInchDiscountedTotal = self.twoInchBlindsCart!.getRoundedDecimal(self.twoInchBlindsCart!.getDiscountedTotal())
                    let shades3DiscountedTotal = self.shades3Cart!.getRoundedDecimal(self.shades3Cart!.getDiscountedTotal())
                    let vienna100DiscountedTotal = self.vienna100Cart!.getRoundedDecimal(self.vienna100Cart!.getDiscountedTotal())
                    
                    return "-$\(cart.getRoundedDecimal(cart.getDiscountedTotal())), -$\(twoInchDiscountedTotal), -$\(shades3DiscountedTotal), -$\(vienna100DiscountedTotal)"
                }
            }
        }
        
        return nil
    }
    
    func getAggregateBalance() -> String? {
        
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if cart.subTotal!.int32Value > 0 {
                    
                    let twoInchBalance = self.twoInchBlindsCart!.getRoundedDecimal(self.twoInchBlindsCart!.getBalance())
                    let shades3Balance = self.shades3Cart!.getRoundedDecimal(self.shades3Cart!.getBalance())
                    let vienna100Balance = self.vienna100Cart!.getRoundedDecimal(self.vienna100Cart!.getBalance())
                    
                    return "$\(cart.getRoundedDecimal(cart.getBalance())), $\(twoInchBalance), $\(shades3Balance), $\(vienna100Balance)"
                }
            }
        }
        
        return nil
    }
    
    
    
    func updateCart() {
        
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                if cart.subTotal!.int32Value > 0 {
                    DispatchQueue.main.async(execute: {
                        
                        if let totalDiscounts = self.getAggregateTotalDiscounts() {
                            
                            let totalDiscountsArr = totalDiscounts.components(separatedBy: ",")
                            
                            if totalDiscountsArr.count == 4{
                                self.totalDiscountsField1.text = totalDiscountsArr[0]
                                self.totalDiscountsField2.text = totalDiscountsArr[1]
                                self.totalDiscountsField3.text = totalDiscountsArr[2]
                                self.totalDiscountsField4.text = totalDiscountsArr[3]
                            }
                        }
                        
                        if let subtotal = self.getAggregateSubtotal() {
                            
                            let subtotalArr = subtotal.components(separatedBy: ",")
                            
                            if subtotalArr.count == 4{
                                self.subTotalField1.text = subtotalArr[0]
                                self.subTotalField2.text = subtotalArr[1]
                                self.subTotalField3.text = subtotalArr[2]
                                self.subTotalField4.text = subtotalArr[3]
                            }
                        }
                        
                        if let discountedTotal = self.getAggregateDiscountedTotal() {
                            
                            let discountedTotalArr = discountedTotal.components(separatedBy: ",")
                            
                            if discountedTotalArr.count == 4{
                                self.discountedTotal1.text = discountedTotalArr[0]
                                self.discountedTotal2.text = discountedTotalArr[1]
                                self.discountedTotal3.text = discountedTotalArr[2]
                                self.discountedTotal4.text = discountedTotalArr[3]
                            }
                        }
                        
                        if let balance = self.getAggregateBalance() {
                            
                            let balanceArr = balance.components(separatedBy: ",")
                            
                            if balanceArr.count == 4{
                                self.balanceField1.text = balanceArr[0]
                                self.balanceField2.text = balanceArr[1]
                                self.balanceField3.text = balanceArr[2]
                                self.balanceField4.text = balanceArr[3]
                            }
                        }
                        
                    })
                }
            }
        }
    }
    
    func setDepositAmount(_ deposit:Double) {
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                cart.deposit = deposit as NSNumber?
                self.twoInchBlindsCart?.deposit = deposit as NSNumber?
                self.shades3Cart?.deposit = deposit as NSNumber?
                self.vienna100Cart?.deposit = deposit as NSNumber?
                DataController.sharedInstance.save()
                self.updateCart()
            }
        }
    }
    
    func setTax(_ tax:Double) {
        if let customer:Customers = DataController.sharedInstance.customer {
            if let cart:Cart = customer.cart as? Cart {
                cart.tax = tax as NSNumber?
                self.twoInchBlindsCart?.tax = tax as NSNumber?
                self.shades3Cart?.tax = tax as NSNumber?
                self.vienna100Cart?.tax = tax as NSNumber?
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
                self.twoInchBlindsCart?.discountPercent = discount as NSNumber?
                self.shades3Cart?.discountPercent = discount as NSNumber?
                self.vienna100Cart?.discountPercent = discount as NSNumber?
                DataController.sharedInstance.save()
                self.updateCart()
            }
        }
    }
    
    func returnEmailStringBase64EncodedImage(image:UIImage) -> String? {
        if let imgData:Data = UIImagePNGRepresentation(image) {
            
            let strBase64 = imgData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
            return strBase64
        }
        return nil
    }
    
    func imageWithView(view:UIView, size:CGSize) -> UIImage?{
        
        var img:UIImage?
        
        if let tableView = view as? UITableView {
            let oldFrame = tableView.frame
            self.tableView.frame = CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: tableView.contentSize.height)
            UIGraphicsBeginImageContextWithOptions(tableView.contentSize, view.isOpaque, 1.0)
            
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self.tableView.frame = oldFrame
            
        }else{
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 1.0)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        if img != nil {
            return img!
        }
        
        return nil
    }
    
    /*
     Image Resizing Techniques: http://bit.ly/1Hv0T6i
     */
    class func scaleUIImageToSize( image: UIImage, size: CGSize) -> UIImage? {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func getScreenshotForView(view:UIView) -> UIImage? {
        //Snapshot image of cart footer view
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let aspectRatio:CGFloat?
        
        if let tableView = view as? UITableView {
            aspectRatio = tableView.contentSize.width / tableView.contentSize.height
        }else{
            aspectRatio = view.bounds.size.width / view.bounds.size.height
        }
        
        let size = CGSize(width: screenWidth - 100, height: (screenWidth/aspectRatio!) - 100)
        
        if let screenshot = self.imageWithView(view: view, size: size) {
            if let scaledScreenshot = CartViewController.scaleUIImageToSize(image: screenshot, size: size) {
                return scaledScreenshot
            }
        }
        
        return nil
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
                    
                    
                    let footerScreenshot = self.getScreenshotForView(view: self.footerView)
                    let imageStringFooter = returnEmailStringBase64EncodedImage(image: footerScreenshot!)!
                    
                    let tableViewScreenshot = self.getScreenshotForView(view: self.tableView)
                    let imageStringTableview = returnEmailStringBase64EncodedImage(image: tableViewScreenshot!)!
                    
                    htmlTable = "Dear \(customerFirstName!) \(customerLastName!),<br/><br/>" +
                        "Email: \(customer.email!) <br/>" +
                        "Address: \(customer.address!) <br/>" +
                        "Phone: \(customer.phoneNumber!) <br/>" +
                        
                        "Expected delivery: \(CartViewController.estimatedDelivery!) <br/><br/>" +
                        
                        "Here the quote you requested. <br/><br/>" +
                        
                        "<img src='data:image/png;base64,\(imageStringTableview)' width='\(tableViewScreenshot!.size.width)' height='\(tableViewScreenshot!.size.height)'><br/><br/>" +
                        
                        "<img src='data:image/png;base64,\(imageStringFooter)' width='\(footerScreenshot!.size.width)' height='\(footerScreenshot!.size.height)'><br/><br/>" +
                        
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
        
        if self.itemsArray != nil && self.itemsArray!.count > 0 {
            cell.populateTableCell(self.itemsArray![indexPath.row] as! Item)
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
        
        delete.backgroundColor = UIColor.red
        location.backgroundColor = UIColor(red: 88.0/255, green: 193.0/255, blue: 91.0/255, alpha: 1)
        width.backgroundColor = UIColor(red: 147.0/255, green: 193.0/255, blue: 149.0/255, alpha: 1)
        height.backgroundColor = UIColor(red: 88.0/255, green: 193.0/255, blue: 91.0/255, alpha: 1)
        quantity.backgroundColor = UIColor(red: 147.0/255, green: 193.0/255, blue: 149.0/255, alpha: 1)
        
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
                                self.reloadCartData()
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
    
}
