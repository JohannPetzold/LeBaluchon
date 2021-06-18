//
//  ServiceError.swift
//  Travel Helper
//
//  Created by Johann Petzold on 17/06/2021.
//

import Foundation

enum ServiceError: Error {
    case noRequest
    case errorOccurred
    case noData
    case badResponse
    case decodeFail
    
    var description: String {
        switch(self) {
        case .noRequest:
            return Localize.noRequestError
        case .errorOccurred:
            return Localize.occurredError
        case .noData:
            return Localize.noDataError
        case .badResponse:
            return Localize.badResponseError
        case .decodeFail:
            return Localize.decodeFailError
        }
    }
}
