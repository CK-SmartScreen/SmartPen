//
//  SmartPenUITests.swift
//  SmartPenUITests
//
//  Created by CK on 17/08/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//

import XCTest

class SmartPenUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPalette() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let app = XCUIApplication()
        let iconSettingNormalElement = app.otherElements.containing(.button, identifier:"icon setting normal").element
        iconSettingNormalElement.swipeUp()
        app.buttons["icon color yellow"].tap()
        iconSettingNormalElement.swipeUp()
        app.buttons["icon color green"].tap()
        iconSettingNormalElement.swipeRight()
        app.buttons["icon color blue"].tap()
        iconSettingNormalElement.swipeUp()
        app.buttons["icon color purple"].tap()
        iconSettingNormalElement.swipeLeft()
    }

    func testShapeTool() {

        let app = XCUIApplication()
        app.buttons["icon freestyle normal"].tap()
        
        let iconSettingNormalElement = app.otherElements.containing(.button, identifier:"icon setting normal").element
        iconSettingNormalElement/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.buttons["icon line normal"].tap()
        iconSettingNormalElement.swipeUp()
        app.buttons["icon oval normal"].tap()
        iconSettingNormalElement/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.buttons["icon rectangle normal"].tap()
        iconSettingNormalElement/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeUp()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.buttons["icon triangle normal"].tap()
        iconSettingNormalElement/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeDown()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        app.buttons["icon polygon normal"].tap()
        iconSettingNormalElement/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeDown()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    }

    func testDeleteAll() {

        let app = XCUIApplication()
        let iconSettingNormalElement = app.otherElements.containing(.button, identifier:"icon setting normal").element
        iconSettingNormalElement.swipeDown()
        app.buttons["icon delete normal"].tap()
        app.alerts["Delete"].buttons["Delete"].tap()
    }

    func testRegistration() {

        let app = XCUIApplication()
        app.buttons["icon account normal"].tap()

        let registerButton = app.buttons["Register"]
        registerButton.tap()

        let userNameTextField = app.textFields["User Name: "]
        userNameTextField.tap()
        userNameTextField.typeText("test77")

        let passwordSecureTextField = app.secureTextFields["Password:"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("P@ss0rd")

        let repeatPasswordSecureTextField = app.secureTextFields["Repeat Password:"]
        repeatPasswordSecureTextField.tap()
        repeatPasswordSecureTextField.tap()
        repeatPasswordSecureTextField.typeText("P@ssw0rd")
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("P@ssw0rd")
        repeatPasswordSecureTextField.tap()
        repeatPasswordSecureTextField.tap()
        repeatPasswordSecureTextField.typeText("P@ssw0rd")

        let occupationTextField = app.textFields["Occupation:"]
        occupationTextField.tap()
        occupationTextField.tap()

        let app2 = app
        app2/*@START_MENU_TOKEN@*/.pickerWheels["Accounting"].press(forDuration: 1.3);/*[[".pickers.pickerWheels[\"Accounting\"]",".tap()",".press(forDuration: 1.3);",".pickerWheels[\"Accounting\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/

        let doneButton = app.toolbars.buttons["Done"]
        doneButton.tap()
        app.textFields["Age Group:"].tap()
        app2/*@START_MENU_TOKEN@*/.pickerWheels["10-18"].press(forDuration: 1.4);/*[[".pickers.pickerWheels[\"10-18\"]",".tap()",".press(forDuration: 1.4);",".pickerWheels[\"10-18\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        doneButton.tap()
        app2/*@START_MENU_TOKEN@*/.buttons["Female"]/*[[".segmentedControls.buttons[\"Female\"]",".buttons[\"Female\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        registerButton.tap()
    }

    func testLogin() {

        let app = XCUIApplication()
        let iconAccountNormalButton = app.buttons["icon account normal"]
        iconAccountNormalButton.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        let textField = element.children(matching: .textField).element
        textField.tap()
        textField.tap()
        textField.typeText("test11")
        let secureTextField = element.children(matching: .secureTextField).element
        secureTextField.tap()
        secureTextField.typeText("P@ssw0rd")
        app.buttons["Login"].tap()
    }
}
