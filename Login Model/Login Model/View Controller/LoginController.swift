//
//  LoginController.swift
//  Login Model
//
//  Created by logesh on 12/13/19.
//  Copyright © 2019 logesh. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var userNameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    let KeyChain : KeyChainModel = KeyChainModel()
   
    @IBAction func loginButton(_ sender: Any) {
        let userPassword = KeyChain.get(userNameTextfield.text!)
        if userPassword != passwordTextfield.text {
            passwordTextfield.layer.borderColor = UIColor.red.cgColor
            passwordTextfield.layer.borderWidth = 1.0
        }
        else
        {
            passwordTextfield.layer.borderColor = UIColor.white.cgColor
            passwordTextfield.layer.borderWidth = 1.0
            
            let alertController = UIAlertController(title: "Success", message: "You have successfully logged into your account and your password is\(userPassword)", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .cancel) { (action:UIAlertAction) in
               
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
