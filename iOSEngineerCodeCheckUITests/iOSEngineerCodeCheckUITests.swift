//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class iOSEngineerCodeCheckUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testSearch() throws {
        // UI tests must launch the application that they test.
        
        let app = XCUIApplication()
        
        app.tables["Empty list"].searchFields.containing(.button, identifier:"Clear text").element.tap()
        
        let sKey = app.keys["S"]
        sKey.tap()
        
        let wKey = app.keys["w"]
        wKey.tap()
        
        let iKey = app.keys["i"]
        iKey.tap()
        
        let fKey = app.keys["f"]
        fKey.tap()
        
        let tKey = app.keys["t"]
        tKey.tap()
        
        app.buttons["Search"].tap()
        app.tables.cells.containing(.staticText, identifier:"apple/swift").element.tap()
        app.navigationBars["iOSEngineerCodeCheck.RepositoryView"].buttons["Search Repository"].tap()
        
    }
}
