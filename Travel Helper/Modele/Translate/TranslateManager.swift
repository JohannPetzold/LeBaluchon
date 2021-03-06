//
//  TranslateManager.swift
//  Travel Helper
//
//  Created by Johann Petzold on 02/06/2021.
//

import Foundation

class TranslateManager {
    
    var translateData = TranslateData()
    
    private var service: APIService
    
    init(service: APIService = APIService.shared) {
        self.service = service
    }
    
    /* Use data or error from makeRequest
     data is decode in JSONTranslate instance */
    func getTranslation(completion: @escaping (_ translation: String?, _ error: Error?) -> Void) {
        guard let requestData = getRequest() else {
            completion(nil, ServiceError.noRequest)
            return
        }
        service.makeRequest(requestData: requestData) { data, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(JSONTranslate.self, from: data) else {
                completion(nil, ServiceError.decodeFail)
                return
            }
            guard let translation = responseJSON.data.translations.first?.translatedText else {
                completion(nil, ServiceError.noData)
                return
            }
            completion(translation, nil)
        }
    }
    
    /* Create an instance of RequestData with */
    private func getRequest() -> RequestData? {
        guard translateData.status == .valid else { return nil }
        var body = [String: String]()
        body["key"] = TRANSLATE_KEY
        body["q"] = translateData.text!
        body["source"] = translateData.source!
        body["target"] = translateData.target!
        body["format"] = "text"
        
        return RequestData(urlString: .translate, http: .post, body: body)
    }
}
