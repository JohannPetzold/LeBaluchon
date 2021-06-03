//
//  JSONWeather.swift
//  Travel Helper
//
//  Created by Johann Petzold on 02/06/2021.
//

import Foundation

struct JSONWeather: Decodable {
    var weather: [Weather]
    var main: Temperature
    var wind: Wind
    var clouds: Cloud
    var sys: System
    var timezone: Int
    var name: String
}

struct Weather: Decodable {
    var main: String
    var description: String
}

struct Temperature: Decodable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
}

struct Wind: Decodable {
    var speed: Double
    var deg: Int
}

struct Cloud: Decodable {
    var all: Int
}

struct System: Decodable {
    var country: String
    var sunrise: Int
    var sunset: Int
}
