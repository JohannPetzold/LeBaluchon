//
//  FakeResponseData.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 23/05/2021.
//

import Foundation

class FakeResponseData {
    
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)
    
    class ResponseError: Error { }
    static let error = ResponseError()
    
    static func correctData(filename: String) -> Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: filename, withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let incorrectData = "erreur".data(using: .utf8)
}
