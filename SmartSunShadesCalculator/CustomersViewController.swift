//
//  CustomersViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 6/29/16.
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


protocol CustomersViewControllerDelegate {
    func didSelectCustomer(_ customer:Customers)
}

class CustomersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var customersTableView:UITableView!
    var savedCustomers:NSArray?
    var indexPathToDelete:IndexPath?
    
    var delegate:CustomersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customersTableView.delegate = self
        self.customersTableView.dataSource = self
        
        self.customersTableView.register(UINib(nibName: "CustomCustomerTableViewCell", bundle: nil), forCellReuseIdentifier: "customersTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomersViewController.managedObjectContextDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.savedCustomers = DataController.sharedInstance.loadCustomers()
    }
    
    func managedObjectContextDidChange(_ notif:Notification) {
        self.loadCustomers()
        self.customersTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.savedCustomers != nil {
            if self.savedCustomers!.count <= 0 {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            return self.savedCustomers!.count
        }
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 113
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CustomCustomerTableViewCell = self.customersTableView!.dequeueReusableCell(withIdentifier: "customersTableViewCell") as! CustomCustomerTableViewCell
        
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
            
            if let created_at = customer.created_at {
                let formatter = DateFormatter()
                formatter.dateStyle = DateFormatter.Style.short
                formatter.timeStyle = .short
                
                let dateString = formatter.string(from: created_at as Date)
                
                cell.createdAtLabel.text = dateString
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.delegate != nil {
            if self.savedCustomers != nil {
                let customer = self.savedCustomers![indexPath.row] as! Customers
                self.delegate?.didSelectCustomer(customer)
            }
        }
        
        let cell:CustomCustomerTableViewCell = tableView.cellForRow(at: indexPath) as! CustomCustomerTableViewCell
        
        cell.contentView.backgroundColor = UIColor(red: 31.0/255, green: 96.0/255, blue: 137.0/255, alpha: 1.0)
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell:CustomCustomerTableViewCell = tableView.cellForRow(at: indexPath) as! CustomCustomerTableViewCell
        
        cell.contentView.backgroundColor = UIColor(red: 28.0/255, green: 85.0/255, blue: 121.0/255, alpha: 1.0)
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //Delete action
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            
            self.indexPathToDelete = indexPath
            
            
            if let customer = self.savedCustomers![indexPath.row] as? Customers {
                let alert = UIAlertController(title: "Delete Customer", message: "Are you sure you want to delete customer with email: \(customer.email!)", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                    do{
                        DataController.sharedInstance.managedObjectContext?.delete(customer)
                        try DataController.sharedInstance.managedObjectContext?.save()
                    }catch{
                        print("An error occurred while attempting to delete customer: \(customer), \(error)")
                    }
                    
                    
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        
        //Load action
        let load = UITableViewRowAction(style: .normal, title: "Load") { (action, indexPath) in
            
            if let customer = self.savedCustomers![indexPath.row] as? Customers {
                let alert = UIAlertController(title: "Load Customer", message: "Are you sure you want to load this customer? \(customer.email!)", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                    DataController.sharedInstance.customer = customer
                    self.delegate?.didSelectCustomer(customer)
                    self.dismiss()
                    
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        delete.backgroundColor = UIColor.red
        
        return [delete, load]
    }
    
    @IBAction func dismiss() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
