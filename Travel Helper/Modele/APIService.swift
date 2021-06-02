//
//  APIService.swift
//  Travel Helper
//
//  Created by Johann Petzold on 01/06/2021.
//

import Foundation

class APIService {
    
    static var shared = APIService()
    private init() { }
    
    private var task: URLSessionDataTask?
    
    private var session = URLSession(configuration: .default)
    
    enum ServiceError: Error {
        case noRequest
        case errorOccured
        case noData
        case badResponse
        case decodeFail
    }
    
    init(session: URLSession) {
        self.session = session
    }
    
    func makeRequest(requestData: RequestData, completion: @escaping (_ result: Data?, _ error: Error?) -> Void) {
        guard let request = createRequest(requestData: requestData) else {
            completion(nil, ServiceError.noRequest)
            return
        }
        
        task?.cancel()
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(nil, ServiceError.errorOccured)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(nil, ServiceError.badResponse)
                    return
                }
                completion(data, nil)
            }
        })
        task?.resume()
    }
    
    private func createRequest(requestData: RequestData) -> URLRequest? {
        if requestData.status == .valid {
            if var components = URLComponents(string: requestData.urlString!.rawValue) {
                components.queryItems = [URLQueryItem]()
                if requestData.body != nil {
                    for (key, value) in requestData.body! {
                        components.queryItems?.append(URLQueryItem(name: key, value: value))
                    }
                }
                if let url = components.url {
                    var request = URLRequest(url: url)
                    request.httpMethod = requestData.http!.rawValue
                    return request
                }
            }
        }
        return nil
    }
}
