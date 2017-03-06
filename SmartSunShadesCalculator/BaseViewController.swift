//
//  BaseViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 7/20/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var nextBtn:UIButton!
    
    var delegate:ShoppingCartControllerDelegate = ShoppingCartController.sharedInstance
    
    override func viewWillAppear(_ animated: Bool) {
        if self.presentingViewController != nil {
            self.toggleNextButton()
        }
    }
    
    func dismiss() {
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func toggleNextButton() {
        DispatchQueue.main.async { 
            self.nextBtn.setTitle("Done", for: UIControlState())
            self.nextBtn.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)
            print("Do nothing")
            
//            self.nextBtn.addTarget(self, action: #selector(BaseViewController.dismiss), for: UIControlEvents.touchUpInside)
            
            
            
            self.nextBtn.addTarget(self, action: #selector(((BaseViewController.dismiss) as (BaseViewController) -> (Void) -> Void)), for: UIControlEvents.touchUpInside)
        }
    }
    
    func changePickerViewFontSize(_ pickerText:String) -> UILabel {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.text = pickerText
        pickerLabel.font = UIFont(name: "Helvetica Neue", size: 28) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50.0
    }

}
