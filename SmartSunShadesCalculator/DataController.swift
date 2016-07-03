//
//  DataController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 6/29/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {
    
    static let sharedInstance = DataController()
    
    var managedObjectContext:NSManagedObjectContext?
    var customer:Customers? {
        didSet {
            if let context = self.managedObjectContext {
                do {
                    print("Customer saved: \(customer)")
                    try context.save()
                }catch {
                    print("\(error)")
                }
                
            }
        }
    }
    
    override init() {
        super.init()
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDel.managedObjectContext
    }
    
    func loadCustomerByEmail(email:String) -> Customers? {
        
        if let context = self.managedObjectContext {
            let request = NSFetchRequest(entityName: "Customers")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "email = %@", email)
            
            do {
                let results:NSArray = try context.executeFetchRequest(request)
                
                if results.count > 0 {
                    print("results found: \(results.count)")
                    if let customer = results[0] as? Customers {
                        self.customer = customer
                        return customer
                    }
                }else{
                    print("No results found")
                }
                
            }catch {
                print("Error getting results: \(error)")
            }
        }
        
        return nil
    }
    
    func loadCustomers() -> NSArray? {
        
        if let context = self.managedObjectContext {
            let request = NSFetchRequest(entityName: "Customers")
            request.returnsObjectsAsFaults = false
            
            do {
                let results:NSArray = try context.executeFetchRequest(request)
                
                if results.count > 0 {
                    return results
                }else{
                    print("No results found")
                }
                
            }catch {
                print("Error getting results: \(error)")
            }
        }
        
        return nil
    }
    
}
