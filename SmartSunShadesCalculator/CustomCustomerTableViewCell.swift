//
//  CustomCustomerTableViewCell.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 7/3/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class CustomCustomerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var phoneLabel:UILabel!
    @IBOutlet weak var addressLabel:UILabel!
    @IBOutlet weak var emailLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.highlighted = false
        self.selectionStyle = .None
        
        
    }
    
}
