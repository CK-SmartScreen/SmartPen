//
//  RegisterViewController.swift
//  SmartPen
//
//  Created by CK on 24/09/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    let userNameRegEx = "\\A\\w{6,18}\\z"
    @IBOutlet weak var invalidNameLabel: UILabel!

    @IBOutlet weak var passwordTxt: UITextField!
    let passwordRegEx = "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[?.!_%@#$&*]).{6,20}"
    @IBOutlet weak var invalidPasswordLabel: UILabel!

    @IBOutlet weak var repeatpasswordTxt: UITextField!
    @IBOutlet weak var invalidRepeatPasswordLabel: UILabel!

    @IBOutlet weak var occupationTxt: UITextField!
    @IBOutlet weak var ageGroupTxt: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    var gender = ""

    let ageArray = ["10-18","19-29","30-45","45-55","56 abve"]
    let occupationArray = ["Accounting","Banking","Construction","Education","Farming","Healthcare","Legal","Mining","Sales","Science","Sport"]

    var people: [NSManagedObject] = []
    let occupationPicker = UIPickerView()
    var occupationDataModel: GroupPickerViewModel!
    let ageGroupPicker = UIPickerView()
    var ageDataModel: GroupPickerViewModel!



    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set option data age Group
        ageDataModel = GroupPickerViewModel()
        ageDataModel.setOptionArray(ageArray)
        
        // Set delegate
        ageGroupPicker.delegate = ageDataModel
        ageGroupPicker.dataSource = ageDataModel
        createAgeGroupPickerView()
        
        // Set option data for occupation Group
        occupationDataModel = GroupPickerViewModel()
        occupationDataModel.setOptionArray(occupationArray)
        
        // Set delegate
        occupationPicker.delegate = occupationDataModel
        occupationPicker.dataSource = occupationDataModel
        createOccupationPickerView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")

        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        print("[Log]\n People's Count:\(people.count) \n")
        let storeUrl = appDelegate.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url
        print(storeUrl!)
    }

    @IBAction func startInputName(_ sender: UITextField) {
        invalidNameLabel.text = ""
    }
    @IBAction func isValidName(_ sender: UITextField) {
        if(!isValidInput(Input: usernameTxt.text as String!, RegEx: userNameRegEx)){
            invalidNameLabel.text = "At least six characters"
        }
    }

    @IBAction func startInputPassword(_ sender: UITextField) {
        invalidPasswordLabel.text = ""
        invalidRepeatPasswordLabel.text = ""
    }

    @IBAction func isValidPassword(_ sender: UITextField) {
        if( !isValidInput(Input: passwordTxt.text as String!, RegEx: passwordRegEx)){
            invalidPasswordLabel.text = "password veriﬁcation fails"
        }
    }

    @IBAction func startRepeatPassword(_ sender: UITextField) {
        invalidRepeatPasswordLabel.text = ""
    }


    @IBAction func repeatPasswordEntered(_ sender: UITextField) {
        if(sender.text != passwordTxt.text){
            invalidRepeatPasswordLabel.text = "Passwords don't match."
        }
    }


    @IBAction func loginPressed(_ sender: Any) {
        if (isValidInput(Input: usernameTxt.text as String!, RegEx: userNameRegEx) && isValidInput(Input: passwordTxt.text as String!, RegEx: passwordRegEx)){
            saveUser()
        } else {
            print("Something wrong!")
        }
    }


    func isValidInput(Input: String, RegEx: String) -> Bool {
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }

    func saveUser() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!

        let user = NSManagedObject(entity: entity, insertInto: managedContext)

        user.setValue(usernameTxt.text as String!, forKeyPath: "username")
        user.setValue(passwordTxt.text as String!, forKey: "password")
        user.setValue(occupationTxt.text as String!, forKey: "occupation")
        user.setValue(ageGroupTxt.text as String!, forKey: "agegroup")
        user.setValue(gender, forKey: "gender")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    @IBAction func genderSelect(_ sender: UISegmentedControl) {
        gender = genderSegment.titleForSegment(at: sender.selectedSegmentIndex)!
        print(gender)
    }


    func createAgeGroupPickerView(){
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        // bar button item
        let doneButton  = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(ageDonePressed))
        toolbar.setItems([doneButton], animated: false)
        ageGroupTxt.inputAccessoryView = toolbar

        // assigning data picker to text field
        ageGroupTxt.inputView = ageGroupPicker
    }
    func ageDonePressed(){
        ageGroupTxt.text = "\(ageDataModel.selectedRow)"
        self.view.endEditing(true)
    }

    func createOccupationPickerView(){
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        // bar button item
        let doneButton  = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(occupationDonePressed))
        toolbar.setItems([doneButton], animated: false)
        occupationTxt.inputAccessoryView = toolbar

        // assigning data picker to text field
        occupationTxt.inputView = occupationPicker
    }
    func occupationDonePressed(){
        occupationTxt.text = "\(occupationDataModel.selectedRow)"
        self.view.endEditing(true)
    }



}
