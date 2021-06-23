//
//  WeatherManager.swift
//  Travel Helper
//
//  Created by Johann Petzold on 02/06/2021.
//

import Foundation

class WeatherManager {
    
    var weatherData = WeatherData()
    
    private var service: APIService
    
    init(service: APIService = APIService.shared) {
        self.service = service
    }
    
    /* Get data or error from makeRequest
     Use data to get an instance of JSONWeather */
    func getWeather(completion: @escaping (_ result: JSONWeather?, _ error: Error?) -> Void) {
        guard let requestData = getRequest() else {
            completion(nil, ServiceError.noRequest)
            return
        }
        service.makeRequest(requestData: requestData) { data, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(JSONWeather.self, from: data) else {
                completion(nil, ServiceError.decodeFail)
                return
            }
            completion(responseJSON, nil)
        }
    }
    
    private func getRequest() -> RequestData? {
        guard weatherData.status != .invalid else { return nil }
        var body = [String: String]()
        if weatherData.status == .validCoord {
            body["lat"] = String(weatherData.lat!)
            body["lon"] = String(weatherData.lon!)
        } else if weatherData.status == .validName {
            body["q"] = weatherData.name
        }
        body["appid"] = WEATHER_KEY
        body["units"] = "metric"
        if weatherData.lang == "fr" {
            body["lang"] = "fr"
        } else {
            body["lang"] = "en"
        }
        
        return RequestData(urlString: .weather, http: .get, body: body)
    }
}
