//
//  RegisterViewController.swift
//  SmartPen
//
//  Created by CK on 24/09/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController{

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
    let ageArray = ["10-18","19-29","30-45","45-55","56 abve"]

    @IBOutlet weak var genderSegment: UISegmentedControl!
    var gender = ""
    let occupationArray = ["Accounting","Banking","Construction","Education","Farming","Healthcare","Legal","Mining","Sales","Science","Sport"]

    @IBOutlet weak var goToLogin: UILabel!
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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

         // [Testing] test the number of registered user and print out the database location
        print("The CoreData DB files stored here:\n")
        let storeUrl = appDelegate.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url
        print(storeUrl!)
    }

    @IBAction func textFieldTouchDown(_ sender: UITextField) {
        invalidNameLabel.text = ""
        invalidPasswordLabel.text = ""
        invalidRepeatPasswordLabel.text = ""
        repeatpasswordTxt.text = ""
    }

    @IBAction func isValidName(_ sender: UITextField) {
        if(!isValidInput(Input: usernameTxt.text as String!, RegEx: userNameRegEx)){
            invalidNameLabel.text = "At least six characters"
            return
        }


        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "username == %@", usernameTxt.text as String!)
        request.predicate = predicate
        request.fetchLimit = 1
        do{
            let count = try managedContext.count(for: request)
            if(count == 0){
                // not Matching user
                return
            }
            else{
                //at least one matching object
                invalidNameLabel.text = "username is in used"
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error)")
        }
    }


    @IBAction func passwordEntered(_ sender: UITextField) {
        if(isValidInput(Input: passwordTxt.text as String!, RegEx: passwordRegEx) || passwordTxt.text == ""){
            return
        }
        invalidPasswordLabel.text = "veriﬁcation failed"
    }

    @IBAction func repeatPasswordEntered(_ sender: UITextField) {
        if(sender.text != passwordTxt.text){
            invalidRepeatPasswordLabel.text = "passwords don't match"
        }
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        if (isValidInput(Input: usernameTxt.text as String!, RegEx: userNameRegEx) &&
            isValidInput(Input: passwordTxt.text as String!, RegEx: passwordRegEx) &&
            occupationTxt.text != "" &&
            ageGroupTxt.text != ""
            ){
            saveUser()
            self.performSegue(withIdentifier: "canvasView", sender: self)
        } else {
            print("Must input all the fields")
        }
    }

    func isValidInput(Input: String, RegEx: String) -> Bool {
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }

    func saveUser() {

        let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
        let item = User(entity: entityDescription!, insertInto: managedContext)
        item.username = usernameTxt.text
        item.password = passwordTxt.text
        item.occupation = occupationTxt.text
        item.agegroup = ageGroupTxt.text
        item.gender = gender

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    @IBAction func genderSelect(_ sender: UISegmentedControl) {
        gender = genderSegment.titleForSegment(at: sender.selectedSegmentIndex)!
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

    @IBAction func backToLoginViewButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

