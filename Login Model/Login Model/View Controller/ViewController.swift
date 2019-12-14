//
//  ViewController.swift
//  Login Model
//
//  Created by logesh on 12/13/19.
//  Copyright © 2019 logesh. All rights reserved.
//

import UIKit


//MARK: - Class
class ViewController: UIViewController {

    //MARK: - Outlets and Action
    @IBOutlet weak var backGround: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confrimPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tabBar: UITabBar!
    
    //MARK: - Class Instances
    let KeyChain : KeyChainModel = KeyChainModel()
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        if passwordTextField.text == confrimPasswordTextField.text && userName.text != " "
        {
            KeyChain.saveUserCredentials(userName: userName.text!, password: passwordTextField.text!)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}


extension ViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
}

