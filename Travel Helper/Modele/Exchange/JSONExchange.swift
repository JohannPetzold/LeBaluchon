//
//  JSONExchange.swift
//  Travel Helper
//
//  Created by Johann Petzold on 20/05/2021.
//

import Foundation

struct JSONExchange: Decodable {
    var success: Bool
    var timestamp: Int
    var base: String
    var date: String
    var rates: JSONCurrencies
}

struct JSONCurrencies: Decodable {
    var USD: Double
    var EUR: Double
    var GBP: Double
    var JPY: Double
    var AUD: Double
    var CAD: Double
    var CHF: Double
    var SEK: Double
    var NZD: Double
}
