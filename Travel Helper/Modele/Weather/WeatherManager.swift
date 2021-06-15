//
//  WeatherManager.swift
//  Travel Helper
//
//  Created by Johann Petzold on 02/06/2021.
//

import Foundation

class WeatherManager {
    
    private var service = APIService(session: URLSession(configuration: .default))
    
    init(session: URLSession? = nil) {
        if let session = session {
            service = APIService(session: session)
        }
    }
    
    func getWeather(location: WeatherData, completion: @escaping (_ result: JSONWeather?, _ error: Error?) -> Void) {
        guard let requestData = getRequest(location: location) else {
            completion(nil, APIService.ServiceError.noRequest)
            return
        }
        service.makeRequest(requestData: requestData) { data, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(JSONWeather.self, from: data) else {
                completion(nil, APIService.ServiceError.decodeFail)
                return
            }
            completion(responseJSON, nil)
        }
    }
    
    private func getRequest(location: WeatherData) -> RequestData? {
        guard location.status != .invalid else { return nil }
        var body = [String: String]()
        if location.status == .validCoord {
            body["lat"] = String(location.lat!)
            body["lon"] = String(location.lon!)
        } else if location.status == .validName {
            body["q"] = location.name
        }
        body["appid"] = WEATHER_KEY
        body["units"] = "metric"
        if location.lang == "fr" {
            body["lang"] = "fr"
        } else {
            body["lang"] = "en"
        }
        
        
        return RequestData(urlString: .weather, http: .get, body: body)
    }
}
