//
//  AllDayJavaUITests.swift
//  AllDayJavaUITests
//
//  Created by Sylvain on 03/05/2017.
//  Copyright © 2017 S.G. inTech. All rights reserved.
//

import XCTest

class AllDayJavaUITests: XCTestCase {
        
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
    
    func testExample() {
        let app = XCUIApplication()
        
        // No identifier for a11y 🙁
        app.tabBars.buttons["Commande"].tap()
        
        let buttons = app.tables.buttons
        
        // Pick a coffee and change you mind! ☕️
        let expressoBtn = buttons.matching(identifier: "cofee-expresso").element
        let americanoBtn = buttons.matching(identifier: "cofee-americano").element
        
        XCTAssertNotNil(expressoBtn)
        XCTAssertNotNil(americanoBtn)
        
        americanoBtn.tap()
        expressoBtn.tap()
        
        // Check the state of buttons is matching our expectations
        XCTAssert(expressoBtn.isSelected)
        XCTAssert(!americanoBtn.isSelected)
        
        // Add some 🍰
        let bakeFld = app.tables.textFields.matching(identifier: "scone-fld").element
            
        bakeFld.tap()
        bakeFld.typeText("2")
        
        // Remove the keyboard
        app.buttons.matching(identifier: "close-kbd").element.tap()
        
        // Confirm purchase
        
        var alertDisplayed = false
        
        addUIInterruptionMonitor(withDescription: "Authorization Dialog") {
            (alert) -> Bool in
            
            alert.buttons["Cancel"].tap()
            alertDisplayed = true
            NSLog("Cancelled authorization.")
            
            return true
        }
        
        
        buttons.matching(identifier: "confirm-order").element.tap()
        
        sleep(1)
        
        app.tap()
        
        XCTAssertTrue(alertDisplayed)
    }
    
}
