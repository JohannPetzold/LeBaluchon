//
//  WeatherViewController.swift
//  Travel Helper
//
//  Created by Johann Petzold on 20/05/2021.
//

import UIKit
import MapKit

class WeatherViewController: MainViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityNameLabel1: UILabel!
    @IBOutlet weak var tempLabel1: UILabel!
    @IBOutlet weak var descriptionLabel1: UILabel!
    @IBOutlet weak var iconDescription1: UIImageView!
    @IBOutlet weak var minMaxLabel1: UILabel!
    @IBOutlet weak var cityNameLabel2: UILabel!
    @IBOutlet weak var tempLabel2: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet weak var iconDescription2: UIImageView!
    @IBOutlet weak var minMaxLabel2: UILabel!
    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var reloadButton: UIButton!
    
    private var locManager = CLLocationManager()
    private var weatherManager = WeatherManager()
    private var myLocationCity = ""
    private var locEnable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locManager.delegate = self
        if #available(iOS 14.0, *) { } else {
            startUpdatingLocation()
        }
        getActualDate()
        getCityWeather(atStart: true)
        changeStateLocateButton()
    }
}

// MARK: - Service
extension WeatherViewController {
    
    /* Get weather datas for first city
     If atStart is true, get weather datas for user city
     If error, present an AlertController */
    private func getCityWeather(atStart: Bool) {
        weatherManager.weatherData.name = "New York"
        weatherManager.getWeather() { [weak self] data, error in
            guard let self = self else { return }
            if data != nil && error == nil {
                self.changeFirstCityLabels(data: data!)
                self.changeStateReloadButton()
                if atStart {
                    self.getCurrentCityAtStart()
                }
            } else if let error = error as? ServiceError {
                var errorMessage: String
                switch error {
                case .noData: errorMessage = Localize.weatherErrorNoData
                case .decodeFail: errorMessage = Localize.weatherErrorDecodeFail
                default: errorMessage = Localize.weatherErrorFirstCity
                }
                let alertVC = self.makeAlertVC(message: errorMessage)
                self.present(alertVC, animated: true, completion: {
                    self.changeStateReloadButton()
                })
            }
        }
    }
    
    /* Get weather for user city if location is available */
    private func getCurrentCityAtStart() {
        guard let location = locManager.location?.coordinate else { return }
        getWeatherFromCoord(location: location)
    }
    
    /* Get weather datas for user city using WeatherData instance in manager
     If error, present an AlertController*/
    private func getCurrentCityWeather() {
        weatherManager.getWeather() { [weak self] data, error in
            guard let self = self else { return }
            if data != nil && error == nil {
                self.changeSecondCityLabels(data: data!)
                if self.weatherManager.weatherData.status == .validCoord {
                    self.myLocationCity = (self.cityNameLabel2.text!)
                }
                self.changeStateLocateButton()
                self.cityTextField.text = ""
            } else if let error = error as? ServiceError {
                var errorMessage: String
                switch error {
                case .noData: errorMessage = Localize.weatherErrorNoData
                case .decodeFail: errorMessage = Localize.weatherErrorDecodeFail
                default: errorMessage = Localize.weatherError
                }
                let alertVC = self.makeAlertVC(message: errorMessage)
                self.present(alertVC, animated: true, completion: {
                    self.cityTextField.text = ""
                })
            }
        }
    }
    
    /* Use getCurrentCityWeather with WeatherData from textField */
    private func getWeatherFromText() {
        if cityTextField.text != "" {
            weatherManager.weatherData = WeatherData(name: cityTextField.text)
            getCurrentCityWeather()
        }
    }
    
    /* Use getCurrentCityWeather with WeatherData from location coordinate */
    private func getWeatherFromCoord(location: CLLocationCoordinate2D) {
        weatherManager.weatherData = WeatherData(lon: location.longitude, lat: location.latitude)
        getCurrentCityWeather()
    }
}

// MARK: - Labels
extension WeatherViewController {
    
    private func getActualDate() {
        dateLabel.text = Date().dateString()
    }
    
    /* Change UI datas with JSONWeather properties */
    private func changeFirstCityLabels(data: JSONWeather) {
        cityNameLabel1.text = data.name
        tempLabel1.text = "\(Int(data.main.temp))°c"
        descriptionLabel1.text = data.weather.first?.description.capitalized ?? ""
        let min = Int(data.main.temp_min)
        let max = Int(data.main.temp_max)
        minMaxLabel1.text = "\(min)°c / \(max)°c"
        iconDescription1.image = UIImage(named: data.weather.first?.icon ?? "")
        iconDescription1.isHidden = false
    }
    
    /* Change UI datas with JSONWeather properties */
    private func changeSecondCityLabels(data: JSONWeather) {
        cityNameLabel2.text = data.name
        tempLabel2.text = "\(Int(data.main.temp))°c"
        descriptionLabel2.text = data.weather.first?.description.capitalized ?? ""
        let min = Int(data.main.temp_min)
        let max = Int(data.main.temp_max)
        minMaxLabel2.text = "\(min)°c / \(max)°c"
        iconDescription2.image = UIImage(named: data.weather.first?.icon ?? "")
        iconDescription2.isHidden = false
    }
}

// MARK: - Reload Button
extension WeatherViewController {
    
    @IBAction func tappedReloadButton(_ sender: UIButton) {
        getCityWeather(atStart: false)
    }
    
    private func changeStateReloadButton() {
        if cityNameLabel1.text != "-" {
            reloadButton.isEnabled = false
            reloadButton.isHidden = true
        } else {
            reloadButton.isEnabled = true
            reloadButton.isHidden = false
        }
    }
}

// MARK: - Locate Button
extension WeatherViewController {
    
    /* Ask authorization if notDetermined yet, or use location coordinate to get weather for user's current city */
    @IBAction func tappedLocate(_ sender: UIButton) {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locManager.requestWhenInUseAuthorization()
        } else {
            guard let location = locManager.location?.coordinate else { return }
            getWeatherFromCoord(location: location)
        }
    }
    
    /* Modify the appearance of the LocateButton */
    private func changeStateLocateButton() {
        if CLLocationManager.authorizationStatus() == .denied {
            locateButton.isEnabled = false
            locateButton.alpha = 0.4
            locateButton.setImage(UIImage(systemName: "location.slash"), for: .disabled)
        } else if cityNameLabel2.text != "-" && cityNameLabel2.text == myLocationCity {
            locateButton.isEnabled = false
            locateButton.alpha = 0.4
            locateButton.setImage(UIImage(systemName: "location.fill"), for: .disabled)
        } else {
            locateButton.isEnabled = true
            locateButton.alpha = 1
        }
    }
}

// MARK: - TextField & Keyboard
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        getWeatherFromText()
        cityTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getWeatherFromText()
        return textField.resignFirstResponder()
    }
}

// MARK: - LocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    /* When the authorization is modified, update location and get current city weather if location available */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        startUpdatingLocation()
        if locManager.location != nil {
            let location = locManager.location!.coordinate
            getWeatherFromCoord(location: location)
        }
        changeStateLocateButton()
    }
    
    private func startUpdatingLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locManager.startUpdatingLocation()
        }
    }
}
