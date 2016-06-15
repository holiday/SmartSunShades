//
//  Customer.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/13/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class Customer: NSObject {
    
    var firstName:String?
    var lastName:String?
    var address:String?
    var email:String?
    
    init(firstName:String, lastName:String, address:String, email:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.email = email
    }

}
