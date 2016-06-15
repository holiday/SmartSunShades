//
//  CartViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 5/15/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let shoppingCart:ShoppingCart = ShoppingCartController.sharedInstance.shoppingCart
    
    @IBOutlet weak var totalDiscountsField: UILabel!
    @IBOutlet weak var subTotalField: UILabel!
    
    override func viewDidLoad() {
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cartTableViewCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        subTotalField.text = "$\(self.shoppingCart.subTotal)"
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
        return 100
    }

}
