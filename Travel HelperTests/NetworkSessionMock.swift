//
//  NetworkSessionMock.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 18/06/2021.
//

import Foundation
@testable import Travel_Helper

class NetworkSessionMock: NetworkSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func loadData(from request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completionHandler(data, response, error)
    }
}
