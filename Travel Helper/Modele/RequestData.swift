//
//  RequestData.swift
//  Travel Helper
//
//  Created by Johann Petzold on 01/06/2021.
//

import Foundation

struct RequestData {
    var urlString: apiUrl?
    var http: httpMethod?
    var body: [String: String]?
    
    enum httpMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum apiUrl: String {
        case exchange = "http://data.fixer.io/api/latest"
        case translate = "https://translation.googleapis.com/language/translate/v2"
        case weather = "https://api.openweathermap.org/data/2.5/weather"
        case test = "https://openclassrooms.com"
    }
    
    enum RequestStatus {
        case valid, invalid
    }
    
    var status: RequestStatus {
        if urlString != nil && http != nil {
            return .valid
        } else {
            return .invalid
        }
    }
}
