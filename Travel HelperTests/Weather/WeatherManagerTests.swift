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
        let session = WeatherManager(service: APIServiceMock(data: nil, error: nil))
        
        session.getWeather() { result, error in
            XCTAssertNil(result)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetWeatherShouldGetErrorWhenUsingError() {
        let session = WeatherManager(service: APIServiceMock(data: nil, error: ResponseDataMock.error))
        
        session.weatherData = weatherData
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getWeather() { result, error in
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldGetErrorWhenUsingBadData() {
        let session = WeatherManager(service: APIServiceMock(data: ResponseDataMock.incorrectData, error: nil))
        
        session.weatherData = weatherData
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getWeather() { result, error in
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldGetResultWhenUsingGoodData() {
        let session = WeatherManager(service: APIServiceMock(data: ResponseDataMock.correctData(filename: filename), error: nil))

        session.weatherData = weatherData
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getWeather() { result, error in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            
            XCTAssertEqual(result!.name, "Mountain View")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeatherShouldGetResultWhenUsingGoodDataWithCoord() {
        let session = WeatherManager(service: APIServiceMock(data: ResponseDataMock.correctData(filename: filename), error: nil))
        
        session.weatherData = weatherDataCoord
        let expectation = XCTestExpectation(description: "Wait for queue change")
        session.getWeather() { result, error in
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            
            XCTAssertEqual(result!.name, "Mountain View")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
