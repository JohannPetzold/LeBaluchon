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
    
    private var session: NetworkSession = URLSession.shared
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    /* This method will call a dataTask with the request you want and return data or error */
    func makeRequest(requestData: RequestData, completion: @escaping (_ result: Data?, _ error: Error?) -> Void) {
        guard let request = createRequest(requestData: requestData) else {
            completion(nil, ServiceError.noRequest)
            return
        }
        
        session.loadData(from: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(nil, ServiceError.errorOccurred)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(nil, ServiceError.badResponse)
                    return
                }
                completion(data, nil)
            }
        })
    }
    
    /* Create an URLRequest from RequestData */
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
