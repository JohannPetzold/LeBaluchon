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
        let session = ExchangeManager(service: APIServiceMock(data: nil, error: ResponseDataMock.error))
        
        session.getExchange { success, error in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetExchangeShouldGetErrorWhenUsingBadData() {
        let session = ExchangeManager(service: APIServiceMock(data: ResponseDataMock.incorrectData, error: nil))
        
        session.getExchange { success, error in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetExchangeShouldGetSuccessWhenUsingGoodData() {
        let session = ExchangeManager(service: APIServiceMock(data: ResponseDataMock.correctData(filename: filename), error: nil))
        
        session.getExchange { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
        }
    }
    
    func testSwapCurrenciesShouldReturnIfNoExchangeJson() {
        ExchangeManager().swapCurrencies(amount: 10, source: .aud, target: .eur) { result in
            XCTAssertNil(result)
        }
    }
    
    func testSwapCurrenciesShouldReturnResultIfGoodData() {
        let session = ExchangeManager(service: APIServiceMock(data: ResponseDataMock.correctData(filename: filename), error: nil))
        
        session.getExchange { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            
            if success {
                session.swapCurrencies(amount: 1, source: .eur, target: .aud) { result in
                    XCTAssertEqual(result, 1.575433)
                }
            }
        }
    }
}
