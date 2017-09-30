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
        
        // Test Palette selection Tool
        XCUIDevice.shared().orientation = .landscapeLeft
        
        let app = XCUIApplication()
        app.buttons["icon color red"].tap()
        
        let iconSettingNormalElement = app.otherElements.containing(.button, identifier:"icon setting normal").element
        iconSettingNormalElement.swipeDown()
        app.buttons["icon color yellow"].tap()
        iconSettingNormalElement.swipeDown()
        app.buttons["icon color green"].tap()
        iconSettingNormalElement.swipeLeft()
        app.buttons["icon color blue"].tap()
        iconSettingNormalElement.swipeLeft()
        app.buttons["icon color purple"].tap()
        iconSettingNormalElement.swipeDown()
    }
    
    func testShape() {
        
        XCUIDevice.shared().orientation = .landscapeLeft
        
        let app = XCUIApplication()
        app.buttons["icon freestyle normal"].tap()
        
        let iconSettingNormalElement = app.otherElements.containing(.button, identifier:"icon setting normal").element
        iconSettingNormalElement.swipeDown()
        app.buttons["icon line normal"].tap()
        iconSettingNormalElement.swipeDown()
        app.buttons["icon oval normal"].tap()
        iconSettingNormalElement.swipeDown()
        app.buttons["icon rectangle normal"].tap()
        iconSettingNormalElement.swipeDown()
        app.buttons["icon polygon normal"].tap()
        iconSettingNormalElement.swipeDown()
        app.buttons["icon eraser normal"].tap()
        iconSettingNormalElement.swipeRight()
        
    }
}
