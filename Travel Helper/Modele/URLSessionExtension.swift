//
//  URLSessionExtension.swift
//  Travel Helper
//
//  Created by Johann Petzold on 18/06/2021.
//

import Foundation

protocol NetworkSession {
    func loadData(from request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

/* Inherit from NetworkSession to mock loadData method and run test without using dataTask */
extension URLSession: NetworkSession {
    
    func loadData(from request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        task.resume()
    }
}
