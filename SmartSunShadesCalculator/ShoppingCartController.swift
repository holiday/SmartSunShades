//
//  DataController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 5/15/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class ShoppingCartController: NSObject {
    
    static let sharedInstance = ShoppingCartController()
    
    var shoppingCart:ShoppingCart!
    var customer:Customer!
    
    override init() {
        super.init()
        self.shoppingCart = ShoppingCart()
        print("Shopping Cart Controller initialized")
    }

}
