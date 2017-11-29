//
//  LoginViewController.swift
//  SmartSunShadesCalculator
//
//  Created by Darko on 10/15/17.
//  Copyright © 2017 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField:UITextField!
    @IBOutlet weak var passwordField:UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didPressLogin(sender:UIButton) {
        
        guard let username = self.usernameField.text else{
            self.showError(message: "Please enter a valid username")
            return
        }
        
        guard let password = self.passwordField.text else{
            self.showError(message: "Please enter a valid password")
            return
        }
        
        if username.characters.count <= 0 {
            self.showError(message: "Please enter a valid username")
            return
        }
        
        if password.characters.count <= 0 {
            self.showError(message: "Please enter a valid password")
            return
        }
        
        print("You entered: \(username), password: \(password)")
        
        if username == "admin" && password == "farhad756" {
            self.showCustomerViewController()
            return
        }
        
        if username == "admin" && password == "dem0!23" {
            self.showCustomerViewController()
            return
        }
        
        self.showError(message: "The username & password you have entered is invalid")
        
    }
    
    func showError(message:String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showCustomerViewController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "CustomerViewController") as! CustomerViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
