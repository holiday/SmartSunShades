//
//  BaseViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 7/20/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var next:UIButton!
    
    var delegate:ShoppingCartControllerDelegate = ShoppingCartController.sharedInstance
    
    override func viewWillAppear(animated: Bool) {
        if self.presentingViewController != nil {
            self.toggleNextButton()
        }
    }
    
    func dismiss() {
        if self.presentingViewController != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func toggleNextButton() {
        dispatch_async(dispatch_get_main_queue()) { 
            self.next.setTitle("Done", forState: UIControlState.Normal)
            self.next.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
            print("Do nothing")
            
            self.next.addTarget(self, action: #selector(BaseViewController.dismiss), forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func changePickerViewFontSize(pickerText:String) -> UILabel {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.whiteColor()
        pickerLabel.text = pickerText
        pickerLabel.font = UIFont(name: "Helvetica Neue", size: 28) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }

}
