//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Богдан Полыгалов on 10.12.2022.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        
        app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
        
        let secondPoster = app.images["Poster"] // ещё раз находим постер
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)  // проверяем, что постеры разные
    }
    
    func testNoButton() {
        let firstPoster = app.images["Poster"]
        
        app.buttons["No"].tap()
        
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }
    
    func testGameFinish() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        
        sleep(2)
        
        let alert = app.alerts["Alert"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testAlertDismiss() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(3)
        }
        
        sleep(2)
        
        let alert = app.alerts["Alert"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(app.alerts["Alert"].exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
    
}
