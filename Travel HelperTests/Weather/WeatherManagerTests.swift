//
//  WeatherManagerTests.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 03/06/2021.
//

import XCTest
@testable import Travel_Helper

class WeatherManagerTests: XCTestCase {
    
    let filename = "Weather"
    let weatherData = WeatherData(name: "Mountain View")
    let weatherDataCoord = WeatherData(lon: -122.08, lat: 37.39)
    
    func testGetWeatherShouldGetErrorWhenNoWeatherData() {
        let session = WeatherManager(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        session.getWeather(location: WeatherData()) { result, error in
            XCTAssertNil(result)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetWeatherShouldGetErrorWhenUsingError() {
        let session = WeatherManager(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getWeather(location: weatherData) { result, error in
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldGetErrorWhenUsingBadResponse() {
        let session = WeatherManager(session: URLSessionFake(data: nil, response: FakeResponseData.responseKO, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getWeather(location: weatherData) { result, error in
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldGetErrorWhenUsingBadData() {
        let session = WeatherManager(session: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getWeather(location: weatherData) { result, error in
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldGetResultWhenUsingGoodData() {
        let session = WeatherManager(session: URLSessionFake(data: FakeResponseData.correctData(filename: filename), response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getWeather(location: weatherData) { result, error in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            
            XCTAssertEqual(result!.name, "Mountain View")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldGetResultWhenUsingGoodDataWithCoord() {
        let session = WeatherManager(session: URLSessionFake(data: FakeResponseData.correctData(filename: filename), response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getWeather(location: weatherDataCoord) { result, error in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            
            XCTAssertEqual(result!.name, "Mountain View")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
