//
//  APIServiceTests.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 02/06/2021.
//

import XCTest
@testable import Travel_Helper

class APIServiceTests: XCTestCase {

    let requestData = RequestData(urlString: .test, http: .get, body: nil)
    let filename = "Exchange"

    func testMakeRequestShouldGetErrorWhenUsingBadRequest() {
        let service = APIService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.makeRequest(requestData: RequestData()) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testMakeRequestShouldGetErrorWhenFakeError() {
        let service = APIService(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.makeRequest(requestData: requestData) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testMakeRequestShouldGetErrorWhenBadResponse() {
        let service = APIService(session: URLSessionFake(data: FakeResponseData.correctData(filename: filename), response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.makeRequest(requestData: requestData) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testMakeRequestShouldGetDataWhenBadData() {
        let service = APIService(session: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.makeRequest(requestData: requestData) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testMakeRequestShouldGetDataWhenGoodDataAndResponse() {
        let service = APIService(session: URLSessionFake(data: FakeResponseData.correctData(filename: filename), response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.makeRequest(requestData: requestData) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
