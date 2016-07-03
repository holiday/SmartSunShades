//
//  CustomersViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 6/29/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import CoreData

protocol CustomersViewControllerDelegate {
    func didSelectCustomer(customer:Customers)
}

class CustomersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var customersTableView:UITableView!
    var savedCustomers:NSArray?
    var indexPathToDelete:NSIndexPath?
    
    var delegate:CustomersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customersTableView.delegate = self
        self.customersTableView.dataSource = self
        
        self.customersTableView.registerNib(UINib(nibName: "CustomCustomerTableViewCell", bundle: nil), forCellReuseIdentifier: "customersTableViewCell")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CustomersViewController.managedObjectContextDidChange), name: NSManagedObjectContextObjectsDidChangeNotification, object: nil)
        
        self.loadCustomers()
        
    }
    
    func loadCustomers() {
        self.savedCustomers = DataController.sharedInstance.loadCustomers()
        
        if self.savedCustomers != nil {
            if self.savedCustomers?.count > 0 {
                print("Loaded saved customers (\(self.savedCustomers!.count))")
            }else{
                self.savedCustomers = []
            }
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        self.savedCustomers = DataController.sharedInstance.loadCustomers()
    }
    
    func managedObjectContextDidChange(notif:NSNotification) {
        self.loadCustomers()
        self.customersTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.savedCustomers != nil {
            if self.savedCustomers!.count <= 0 {
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
            return self.savedCustomers!.count
        }
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 113
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:CustomCustomerTableViewCell = self.customersTableView!.dequeueReusableCellWithIdentifier("customersTableViewCell") as! CustomCustomerTableViewCell
        
        if self.savedCustomers != nil {
            let customer = self.savedCustomers![indexPath.row] as! Customers
            if let firstName = customer.firstName {
                if let lastName = customer.lastName {
                    cell.nameLabel?.text = "\(firstName) \(lastName)"
                }else{
                    cell.nameLabel?.text = "\(firstName)"
                }
            }else {
                cell.nameLabel?.text = "N/A"
            }
            
            if let address = customer.address {
                cell.addressLabel?.text = address
            }else{
                cell.addressLabel?.text = "N/A"
            }
            
            if let phone = customer.phoneNumber {
                cell.phoneLabel?.text = phone
            }else{
                cell.phoneLabel?.text = "N/A"
            }
            
            if let email = customer.email {
                cell.emailLabel?.text = email
            }else{
                cell.emailLabel?.text = "N/A"
            }
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.delegate != nil {
            if self.savedCustomers != nil {
                let customer = self.savedCustomers![indexPath.row] as! Customers
                self.delegate?.didSelectCustomer(customer)
            }
        }
        
        let cell:CustomCustomerTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! CustomCustomerTableViewCell
        
        cell.contentView.backgroundColor = UIColor(red: 31.0/255, green: 96.0/255, blue: 137.0/255, alpha: 1.0)
        
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell:CustomCustomerTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! CustomCustomerTableViewCell
        
        cell.contentView.backgroundColor = UIColor(red: 28.0/255, green: 85.0/255, blue: 121.0/255, alpha: 1.0)
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //Delete action
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { (action, indexPath) in
            
            self.indexPathToDelete = indexPath
            
            
            if let customer = self.savedCustomers![indexPath.row] as? Customers {
                let alert = UIAlertController(title: "Delete Customer", message: "Are you sure you want to delete customer with email: \(customer.email!)", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                    
                    do{
                        DataController.sharedInstance.managedObjectContext?.deleteObject(customer)
                        try DataController.sharedInstance.managedObjectContext?.save()
                    }catch{
                        print("An error occurred while attempting to delete customer: \(customer), \(error)")
                    }
                    
                    
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            
        }
        
        //Load action
        let load = UITableViewRowAction(style: .Normal, title: "Load") { (action, indexPath) in
            
            if let customer = self.savedCustomers![indexPath.row] as? Customers {
                let alert = UIAlertController(title: "Load Customer", message: "Are you sure you want to load this customer? \(customer.email!)", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                    
                    DataController.sharedInstance.customer = customer
                    self.delegate?.didSelectCustomer(customer)
                    self.dismiss()
                    
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
        
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, load]
    }
    
    @IBAction func dismiss() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
