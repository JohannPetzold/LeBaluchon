//
//  ExchangeServiceTests.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 20/05/2021.
//

import XCTest
@testable import Travel_Helper

class ExchangeServiceTests: XCTestCase {

    func testGetExchangeShouldGetErrorCallBackIfError() {
        let exchangeService = ExchangeService(session: URLSessionFake(data: nil, response: nil, error: FakeExchangeResponseData.error))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        exchangeService.getExchange { exchange, error in
            XCTAssertNotNil(error)
            XCTAssertNil(exchange)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeShouldGetErrorCallBackIfNoData() {
        let exchangeService = ExchangeService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        exchangeService.getExchange { exchange, error in
            XCTAssertNotNil(error)
            XCTAssertNil(exchange)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeShouldGetErrorCallBackIfIncorrectResponse() {
        let exchangeService = ExchangeService(session: URLSessionFake(data: FakeExchangeResponseData.exchangeCorrectData, response: FakeExchangeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        exchangeService.getExchange { exchange, error in
            XCTAssertNotNil(error)
            XCTAssertNil(exchange)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeShouldGetErrorCallBackIfIncorrectData() {
        let exchangeService = ExchangeService(session: URLSessionFake(data: FakeExchangeResponseData.exchangeIncorrectData, response: FakeExchangeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        exchangeService.getExchange { exchange, error in
            XCTAssertNotNil(error)
            XCTAssertNil(exchange)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeShouldGetExchangeCallBackIfCorrectData() {
        let exchangeService = ExchangeService(session: URLSessionFake(data: FakeExchangeResponseData.exchangeCorrectData, response: FakeExchangeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        exchangeService.getExchange { exchange, error in
            XCTAssertNil(error)
            XCTAssertNotNil(exchange)
            
            XCTAssertEqual(exchange!.date, "2021-05-23")
            XCTAssertEqual(exchange!.rates.USD, 1.218125)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
