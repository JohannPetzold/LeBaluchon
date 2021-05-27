//
//  TranslateService.swift
//  Travel Helper
//
//  Created by Johann Petzold on 25/05/2021.
//

import Foundation

class TranslateService {
    
    static var shared = TranslateService()
    private init() { }
    
    private static let translateUrl = URL(string: TRANSLATE_BASEURL)!
    
    private var task: URLSessionDataTask?
    
    private var translateSession = URLSession(configuration: .default)
    
    enum translateError: Error {
        case noRequest
        case errorOccured
        case badResponse
        case noData
    }
    
    init(session: URLSession) {
        self.translateSession = session
    }
    
    func translate(data: TranslateData, completion: @escaping (_ translation: String?, _ error: Error?) -> Void) {
        guard data.status == .valid else { return }
        var body = [String: String]()
        body["key"] = TRANSLATE_KEY
        body["q"] = data.text!
        body["source"] = data.source!
        body["target"] = data.target!
        body["format"] = "text"
        
        makeRequest(body: body) { result, error in
            guard let result = result, let translation = result.data.translations.first?.translatedText else {
                completion(nil, error)
                return
            }
            completion(translation, nil)
        }
    }
    
    private func makeRequest(body: [String: String], completion: @escaping (_ result: JSONTranslate?, _ error: Error?) -> Void) {
        guard let request = createTranslateRequest(body: body) else {
            completion(nil, translateError.noRequest)
            return
        }
        
        task?.cancel()
        task = translateSession.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(nil, translateError.errorOccured)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 201 else {
                    completion(nil, translateError.badResponse)
                    return
                }
                guard let response = try? JSONDecoder().decode(JSONTranslate.self, from: data) else {
                    completion(nil, translateError.noData)
                    return
                }
                completion(response, nil)
            }
        })
        task?.resume()
    }
    
    private func createTranslateRequest(body: [String: String]) -> URLRequest? {
        if var components = URLComponents(string: TRANSLATE_BASEURL) {
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in body {
                components.queryItems?.append(URLQueryItem(name: key, value: value))
            }
            if let url = components.url {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                return request
            }
        }
        return nil
    }
}
