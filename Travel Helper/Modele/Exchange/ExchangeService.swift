//
//  ExchangeRequest.swift
//  Travel Helper
//
//  Created by Johann Petzold on 20/05/2021.
//

import Foundation

class ExchangeService {
    
    static var shared = ExchangeService()
    private init() { }
    
    private static let fixerUrl = URL(string: FIXER_BASEURL + FIXER_ENDPOINT + FIXER_KEY_PARAMETER + FIXER_KEY)!
    
    private var task: URLSessionDataTask?
    
    private var fixerSession = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.fixerSession = session
    }
    
    func getExchange(completion: @escaping (_ result: JSONExchange?, _ error: String?) -> Void) {
        let request = createExchangeRequest()
        
        task?.cancel()
        task = fixerSession.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(nil, "")
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(nil, "")
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(JSONExchange.self, from: data) else {
                    completion(nil, "")
                    return
                }
                completion(responseJSON, nil)
            }
        })
        task?.resume()
    }
    
    private func createExchangeRequest() -> URLRequest {
        var request = URLRequest(url: ExchangeService.fixerUrl)
        request.httpMethod = "GET"
        
        return request
    }
}
