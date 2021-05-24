//
//  ExchangeManager.swift
//  Travel Helper
//
//  Created by Johann Petzold on 24/05/2021.
//

import Foundation

class ExchangeManager {
    
    var exchangeJson: JSONExchange?
    private var rates: [Currencies: Double] = [:]
    
    func updateExchange(exchangeData: JSONExchange) {
        self.exchangeJson = exchangeData
        self.getRates()
    }
    
    func swapCurrencies(amount: Double, currency: Currencies, target: Currencies, completion: (Double) -> Void) {
        guard exchangeJson != nil else { return }
        guard rates[currency] != nil, rates[target] != nil else { return }
        
        let result = amount * (1 / rates[currency]!) * rates[target]!
        completion(result)
    }
    
    private func getRates() {
        guard exchangeJson != nil else { return }
        let jsonRates = exchangeJson!.rates
        for currency in Currencies.allCases {
            switch currency {
            case .usd: rates[.usd] = jsonRates.USD
            case .eur: rates[.eur] = jsonRates.EUR
            case .gbp: rates[.gbp] = jsonRates.GBP
            case .jpy: rates[.jpy] = jsonRates.JPY
            case .aud: rates[.aud] = jsonRates.AUD
            case .cad: rates[.cad] = jsonRates.CAD
            case .chf: rates[.chf] = jsonRates.CHF
            case .sek: rates[.sek] = jsonRates.SEK
            case .nzd: rates[.nzd] = jsonRates.NZD
            }
        }
    }
}
