//
//  WeatherData.swift
//  Travel Helper
//
//  Created by Johann Petzold on 02/06/2021.
//

import Foundation

struct WeatherData {
    var lon: Double?
    var lat: Double?
    var name: String?
    
    init(lon: Double? = nil, lat: Double? = nil, name: String? = nil) {
        self.lon = lon
        self.lat = lat
        self.name = name
    }
    
    enum DataStatus {
        case validCoord
        case validName
        case invalid
    }
    
    var status: DataStatus {
        if lon != nil && lat != nil && name == nil {
            return .validCoord
        } else if lon == nil && lat == nil && name != nil {
            return .validName
        } else {
            return .invalid
        }
    }
}
