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
        let service = APIService(session: NetworkSessionMock(data: nil, response: nil, error: nil))
//        let service = APIService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.makeRequest(requestData: RequestData()) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testMakeRequestShouldGetErrorWhenFakeError() {
        let service = APIService(session: NetworkSessionMock(data: nil, response: nil, error: ResponseDataMock.error))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.makeRequest(requestData: requestData) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testMakeRequestShouldGetErrorWhenBadResponse() {
        let service = APIService(session: NetworkSessionMock(data: ResponseDataMock.correctData(filename: filename), response: ResponseDataMock.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.makeRequest(requestData: requestData) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testMakeRequestShouldGetDataWhenBadData() {
        let service = APIService(session: NetworkSessionMock(data: ResponseDataMock.incorrectData, response: ResponseDataMock.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.makeRequest(requestData: requestData) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testMakeRequestShouldGetDataWhenGoodDataAndResponse() {
        let service = APIService(session: NetworkSessionMock(data: ResponseDataMock.correctData(filename: filename), response: ResponseDataMock.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.makeRequest(requestData: requestData) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
