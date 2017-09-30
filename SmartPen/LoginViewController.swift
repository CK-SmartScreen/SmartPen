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
    @IBOutlet weak var loginFailureLabel: UILabel!

    var delegate: setUserNameDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup View
        usernameTextField.becomeFirstResponder()
    }

    @IBAction func textFieldTouchDown(_ sender: UITextField) {
        loginFailureLabel.text = ""
    }


    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text else {
            loginFailureLabel.text = "Text Field not Found!"
            return
        }

        if(username.characters.count < 6){
            loginFailureLabel.text = "User Name must be at least six characters"
            return
        }

        guard let password = passwordTextField.text else {
            loginFailureLabel.text = "Text Field not Found!"
            return
        }

        if(password.characters.count == 0){
            loginFailureLabel.text = "Password must not empty!"
            return
        }


        // Password Verification
        let (valid, text) = retrievePassword(Username: username, Password: password)

        if (valid){
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
                print("The Error Mesg: \(error)")
                return
            }

            // go to canvas page
            self.dismiss(animated: true, completion: nil)

            // pass current User Name to CanvasView
            self.delegate?.setUserName(usernameTextField.text as String!)

        } else {
            // login fail
            loginFailureLabel.text = text
        }
    }

    @IBAction func skipLoginButtonTapped(_ sender: UIButton) {
        // go back to canvas page
        self.dismiss(animated: true, completion: nil)
    }

    func retrievePassword(Username username: String, Password inputedPassword: String) -> (valid: Bool, result: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return (false, "")
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "username == %@", username)
        request.predicate = predicate
        request.fetchLimit = 1
        do{
            let count = try managedContext.count(for: request)
            if(count == 0){
                // not Matching user
                return (false, "Sorry, we don't recognise this username.")
            }
            else{
                //at least one matching object
                let result = try managedContext.fetch(request) as! [NSManagedObject]
                let user = result[0]
                let password = user.value(forKeyPath: "password") as? String
                if (password == inputedPassword){
                    return (true, "")
                } else {
                    return (false, "The username and password you entered did not \nmatch our records. Please try again.")
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error)")
        }
        return(false, "Cannot connect to database, please contact administrator.")
    }
}
