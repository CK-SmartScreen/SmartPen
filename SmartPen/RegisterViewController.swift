//
//  RegisterViewController.swift
//  SmartPen
//
//  Created by CK on 24/09/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var occupationTxt: UITextField!
    @IBOutlet weak var ageGroupTxt: UITextField!

    let ageArray = ["10-18","19-29","30-45","45-55","56 abve"]
    let occupationArray = ["Accounting","Banking","Construction","Education","Farming","Healthcare","Legal","Mining","Sales","Science","Sport"]
    let ageGroupPicker = UIPickerView()
    let occupationPicker = UIPickerView()

    var ageDataModel: GroupPickerViewModel!
    var occupationDataModel: GroupPickerViewModel!

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
