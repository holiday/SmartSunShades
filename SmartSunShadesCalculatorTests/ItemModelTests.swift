//
//  ItemModel.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 6/29/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import XCTest
import CoreData

class ItemModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateItem() {
        let context:NSManagedObjectContext = DataController().managedObjectContext
        
        let ent = NSEntityDescription.entityForName("Item", inManagedObjectContext: context)
        
        var newItem = Item(entity: ent!, insertIntoManagedObjectContext: context)
        newItem.groupName = "Hello World"
        
        do {
            try context.save()
        }catch {
            print("Error saving")
        }
        
    }
    
}
