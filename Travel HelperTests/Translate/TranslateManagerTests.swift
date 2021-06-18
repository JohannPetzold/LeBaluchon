//
//  TranslateManagerTests.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 02/06/2021.
//

import XCTest
@testable import Travel_Helper

class TranslateManagerTests: XCTestCase {

    let filename = "Translate"
    let translateData = TranslateData(text: "Bonjour", source: "fr", target: "en")
    
    func testGetTranslateShouldGetErrorWhenNoTranslateData() {
        let session = TranslateManager(service: APIServiceMock(data: nil, error: nil))
        
        session.getTranslation { translation, error in
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetTranslationShouldGetErrorWhenUsingError() {
        let session = TranslateManager(service: APIServiceMock(data: nil, error: ResponseDataMock.error))
        session.translateData = translateData
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getTranslation { translation, error in
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldGetErrorWhenUsingBadData() {
        let session = TranslateManager(service: APIServiceMock(data: ResponseDataMock.incorrectData, error: nil))
        session.translateData = translateData
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getTranslation { translation, error in
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldGetTranslationWhenUsingGoodData() {
        let session = TranslateManager(service: APIServiceMock(data: ResponseDataMock.correctData(filename: filename), error: nil))
        session.translateData = translateData
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getTranslation { translation, error in
            XCTAssertNotNil(translation)
            XCTAssertNil(error)
            
            XCTAssertEqual(translation, "Hello")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
