//
//  LoginViewController.swift
//  SmartPen
//
//  Created by CK on 27/09/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit
import CoreData

protocol setUserNameDelegate {
    func setUserName(_ userName: String)
}

class LoginViewController: UIViewController {

    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var delegate: setUserNameDelegate?

    @IBAction func loginButtonTapped(_ sender: UIButton) {

        let dataTool = CoreDataTools(EntityName: "User")
        // check the username & password
        if( passwordTextField.text as String! == dataTool.retrivePassword(Username: usernameTextField.text as String!)){
            print("Successfull")
        }else{
            print("Fail")
        }

        // save login record
        let entityDescription = NSEntityDescription.entity(forEntityName: "Log", in: managedContext)
        let item = Log(entity: entityDescription!, insertInto: managedContext)
        item.username = usernameTextField.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "en_NZ") as TimeZone!
        item.logintime = dateFormatter.string(for: Date())

        do {
            try managedContext.save()
        }
        catch {
            print(error)
            return
        }

        // go to canvas page
        self.dismiss(animated: true, completion: nil)
        
        // set current User Name
        self.delegate?.setUserName(usernameTextField.text as String!)
    }

    @IBAction func skipLoginButtonTapped(_ sender: UIButton) {
        // go back to canvas page
        self.dismiss(animated: true, completion: nil)
    }
}
