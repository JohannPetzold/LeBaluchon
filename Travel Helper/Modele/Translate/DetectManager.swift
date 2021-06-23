//
//  DetectManager.swift
//  Travel Helper
//
//  Created by Johann Petzold on 10/06/2021.
//

import Foundation

class DetectManager {
    
    var detectData = DetectData()
    
    private var service: APIService
    
    init(service: APIService = APIService.shared) {
        self.service = service
    }
    
    /* Get data or error from makeRequest
     Use data to instance JSONDetect */
    func getDetection(completion: @escaping (_ language: String?, _ error: Error?) -> Void) {
        guard let requestData = getRequest() else {
            completion(nil, ServiceError.noRequest)
            return
        }
        service.makeRequest(requestData: requestData) { data, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(JSONDetect.self, from: data) else {
                completion(nil, ServiceError.decodeFail)
                return
            }
            guard let language = responseJSON.data.detections.first?.first?.language else {
                completion(nil, ServiceError.noData)
                return
            }
            completion(language, nil)
        }
    }
    
    /* Make an instance of RequestData */
    private func getRequest() -> RequestData? {
        guard detectData.status == .valid else { return nil }
        var body = [String: String]()
        body["key"] = TRANSLATE_KEY
        body["q"] = detectData.text!
        
        return RequestData(urlString: .detect, http: .post, body: body)
    }
}
