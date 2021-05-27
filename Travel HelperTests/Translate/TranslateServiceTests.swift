//
//  TranslateServiceTests.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 27/05/2021.
//

import XCTest
@testable import Travel_Helper

class TranslateServiceTests: XCTestCase {

    let filename = "Translate"
    let badTranslateData = TranslateData()
    let translateData = TranslateData(text: "Bonjour", source: "fr", target: "en")
    
    func testTranslateShouldDoNothingIfBadData() {
        let translateService = TranslateService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        translateService.translate(data: badTranslateData) { translation, error in
            XCTAssertNil(translation)
            XCTAssertNil(error)
        }
    }
    
    func testTranslateShouldGetErrorIfGoodDataAndFakeError() {
        let translateService = TranslateService(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.translate(data: translateData) { translation, error in
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTranslateShouldGetErrorIfGoodTranslateDataAndNoData() {
        let translateService = TranslateService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.translate(data: translateData) { translation, error in
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTranslateShouldGetErrorIfGoodTranslateDataAndBadResponse() {
        let translateService = TranslateService(session: URLSessionFake(data: FakeResponseData.correctData(filename: filename), response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.translate(data: translateData) { translation, error in
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTranslateShouldGetErrorIfGoodTranslateDataAndBadData() {
        let translateService = TranslateService(session: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.translate(data: translateData) { translation, error in
            XCTAssertNil(translation)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTranslateShouldGetTranslationIfGoodTranslateDataAndGoodData() {
        let translateService = TranslateService(session: URLSessionFake(data: FakeResponseData.correctData(filename: filename), response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        translateService.translate(data: translateData) { translation, error in
            XCTAssertNotNil(translation)
            XCTAssertNil(error)
            
            XCTAssertEqual(translation, "Hello")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
