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
    private let fixerKeyParameter = "access_key"
    
    private var service = APIService(session: URLSession(configuration: .default))
    
    init(session: URLSession? = nil) {
        if let session = session {
            service = APIService(session: session)
        }
    }
    
    func getExchange(completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let requestData = getRequest()
        service.makeRequest(requestData: requestData) { data, error in
            guard let data = data, error == nil else {
                completion(false, error)
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(JSONExchange.self, from: data) else {
                completion(false, APIService.ServiceError.decodeFail)
                return
            }
            self.updateExchange(exchangeData: responseJSON)
            completion(true, nil)
        }
    }
    
    func swapCurrencies(amount: Double, currency: Currencies, target: Currencies, completion: (Double) -> Void) {
        guard exchangeJson != nil else { return }
        guard rates[currency] != nil, rates[target] != nil else { return }
        
        let result = amount * (1 / rates[currency]!) * rates[target]!
        completion(result)
    }
    
    private func updateExchange(exchangeData: JSONExchange) {
        self.exchangeJson = exchangeData
        self.getRates()
    }
    
    private func getRequest() -> RequestData {
        return RequestData(urlString: .exchange, http: .get, body: [fixerKeyParameter: EXCHANGE_KEY])
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
