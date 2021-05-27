//
//  ExchangeManagerTests.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 24/05/2021.
//

import XCTest
@testable import Travel_Helper

class ExchangeManagerTests: XCTestCase {

    let filename = "Exchange"
    
    func testUpdateExchangeShouldUpdatePropertiesWithCorrectData() {
        let exchangeService = ExchangeService(session: URLSessionFake(data: FakeResponseData.correctData(filename: filename), response: FakeResponseData.responseOK, error: nil))
        let manager = ExchangeManager()
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        exchangeService.getExchange { exchange, error in
            if exchange != nil {
                manager.updateExchange(exchangeData: exchange!)
            }
            XCTAssertNotNil(manager.exchangeJson)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testUpdateExchangeShouldFailWithIncorrectData() {
        let exchangeService = ExchangeService(session: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        let manager = ExchangeManager()
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        exchangeService.getExchange { exchange, error in
            XCTAssertNil(manager.exchangeJson)
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSwapCurrenciesShouldFailWithIncorrectData() {
        var testResult: Double = 0
        ExchangeManager().swapCurrencies(amount: 10, currency: .aud, target: .eur) { result in
            testResult = result
            XCTAssertEqual(testResult, 0)
        }
    }
    
    func testSwapCurrenciesShouldReturnResultWithCorrectData() {
        let exchangeService = ExchangeService(session: URLSessionFake(data: FakeResponseData.correctData(filename: filename), response: FakeResponseData.responseOK, error: nil))
        let manager = ExchangeManager()
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        exchangeService.getExchange { exchange, error in
            if exchange != nil {
                manager.updateExchange(exchangeData: exchange!)
                manager.swapCurrencies(amount: 1, currency: .eur, target: .usd) { result in
                    XCTAssertEqual(result, 1.218125)
                }
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
