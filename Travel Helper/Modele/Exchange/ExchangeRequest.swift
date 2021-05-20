//
//  ExchangeRequest.swift
//  Travel Helper
//
//  Created by Johann Petzold on 20/05/2021.
//

import Foundation

class ExchangeRequest {
    
    var completion: ((_ result: JSONExchange?, _ error: String?) -> Void)?
    
    func start(completion: ((_ result: JSONExchange?, _ error: String?) -> Void)?) {
        self.completion = completion
        let urlString = FIXER_BASEURL + FIXER_ENDPOINT + FIXER_KEY_PARAMETER + FIXER_KEY
        guard let url = URL(string: urlString) else { completion?(nil, "Mauvais URL"); return }
        URLSession.shared.dataTask(with: url, completionHandler: response).resume()
    }
    
    private func response(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        DispatchQueue.main.async {
            if let d = data {
                do {
                    let result = try JSONDecoder().decode(JSONExchange.self, from: d)
                    self.completion?(result, nil)
                } catch {
                    self.completion?(nil, error.localizedDescription)
                }
            } else {
                self.completion?(nil, error?.localizedDescription)
            }
        }
    }
}
