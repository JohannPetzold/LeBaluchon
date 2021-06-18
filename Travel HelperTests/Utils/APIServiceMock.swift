//
//  APIServiceFake.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 17/06/2021.
//

import Foundation
@testable import Travel_Helper

class APIServiceMock: APIService {
    
    var data: Data?
    var error: Error?
    
    init(data: Data? = nil, error: Error? = nil) {
        super.init(session: URLSession(configuration: .default))
        self.data = data
        self.error = error
    }
    
    override func makeRequest(requestData: RequestData, completion: @escaping (Data?, Error?) -> Void) {
        completion(data, error)
    }
}
