//
//  ExchangeManagerTests.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 02/06/2021.
//

import XCTest
@testable import Travel_Helper

class ExchangeManagerTests: XCTestCase {

    let filename = "Exchange"
    
    func testGetExchangeShouldGetErrorWhenUsingError() {
        let session = ExchangeManager(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getExchange { success, error in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeShouldGetErrorWhenUsingBadData() {
        let session = ExchangeManager(session: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getExchange { success, error in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeShouldGetErrorWhenUsingBadResponse() {
        let session = ExchangeManager(session: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getExchange { success, error in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeShouldGetSuccessWhenUsingGoodData() {
        let session = ExchangeManager(session: URLSessionFake(data: FakeResponseData.correctData(filename: filename), response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getExchange { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSwapCurrenciesShouldReturnIfNoExchangeJson() {
        ExchangeManager().swapCurrencies(amount: 10, source: .aud, target: .eur) { result in
            XCTAssertNil(result)
        }
    }
    
    func testSwapCurrenciesShouldReturnResultIfGoodData() {
        let session = ExchangeManager(session: URLSessionFake(data: FakeResponseData.correctData(filename: filename), response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getExchange { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            
            if success {
                session.swapCurrencies(amount: 1, source: .eur, target: .aud) { result in
                    XCTAssertEqual(result, 1.575433)
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
