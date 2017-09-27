//
//  LoginViewController.swift
//  SmartPen
//
//  Created by CK on 27/09/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!


    @IBAction func loginButtonTapped(_ sender: UIButton) {

        let userEntry = CoreDataTools(EntityName: "User")
        // check the username & password
        if( passwordTextField.text as String! == userEntry.retrivePassword(Username: usernameTextField.text as String!)){

            print("Successfull")
        }else{
            print("Fail")
        }

        // save login record

        // go to canvas page
    }

}
