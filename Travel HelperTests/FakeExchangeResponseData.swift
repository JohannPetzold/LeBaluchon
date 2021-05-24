//
//  FakeExchangeResponseData.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 23/05/2021.
//

import Foundation

class FakeExchangeResponseData {
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 501, httpVersion: nil, headerFields: nil)
    
    class ExchangeError: Error { }
    static let error = ExchangeError()
    
    static var exchangeCorrectData: Data {
        let bundle = Bundle(for: FakeExchangeResponseData.self)
        let url = bundle.url(forResource: "Quote", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let exchangeIncorrectData = "erreur".data(using: .utf8)
}
