//
//  ExchangeRequestTests.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 20/05/2021.
//

import XCTest
@testable import Travel_Helper

class FixerRequestTests: XCTestCase {

    let fixer = ExchangeRequest()
    
    func testGivenCallToAPI_WhenUsingGetLatest_ThenGetUSDRate() {
        let expectation = XCTestExpectation(description: "Récupère un JSON Exchange")
        
        fixer.start { result, error in
            if result != nil {
                XCTAssertTrue(result!.success)
                expectation.fulfill()
            }
            if error != nil {
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }

}
