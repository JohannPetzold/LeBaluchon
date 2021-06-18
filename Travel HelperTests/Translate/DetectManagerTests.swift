//
//  DetectManagerTests.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 15/06/2021.
//

import XCTest
@testable import Travel_Helper

class DetectManagerTests: XCTestCase {

    let filename = "Detect"
    let detectData = DetectData(text: "Hello")

    func testGetDetectionShouldGetErrorWhenNoDetectData() {
        let session = DetectManager(service: APIServiceMock(data: nil, error: nil))
        
        session.getDetection { detection, error in
            XCTAssertNil(detection)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetDetectionShouldGetErrorWhenUsingError() {
        let session = DetectManager(service: APIServiceMock(data: nil, error: ResponseDataMock.error))
        session.detectData = detectData
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getDetection { detection, error in
            XCTAssertNil(detection)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDetectionShouldGetErrorWhenUsingBadData() {
        let session = DetectManager(service: APIServiceMock(data: ResponseDataMock.incorrectData, error: nil))
        session.detectData = detectData
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getDetection { detection, error in
            XCTAssertNil(detection)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetDetectionShouldGetErrorWhenUsingGoodData() {
        let session = DetectManager(service: APIServiceMock(data: ResponseDataMock.correctData(filename: filename), error: nil))
        session.detectData = detectData
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getDetection { detection, error in
            XCTAssertNotNil(detection)
            XCTAssertNil(error)
            
            XCTAssertEqual(detection, "en")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
