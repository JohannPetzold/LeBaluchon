//
//  WeatherViewController.swift
//  Travel Helper
//
//  Created by Johann Petzold on 20/05/2021.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityNameLabel1: UILabel!
    @IBOutlet weak var tempLabel1: UILabel!
    @IBOutlet weak var descriptionLabel1: UILabel!
    @IBOutlet weak var minMaxLabel1: UILabel!
    @IBOutlet weak var cityNameLabel2: UILabel!
    @IBOutlet weak var tempLabel2: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet weak var minMaxLabel2: UILabel!
    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var reloadButton: UIButton!
    
    private var locManager = CLLocationManager()
    private var location = CLLocationCoordinate2D()
    private var myLocationCity = ""
    private var locEnable: Bool = false
    private var errorService: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locManager.requestWhenInUseAuthorization()
        if !(CLLocationManager.authorizationStatus() == .denied) {
            locEnable = true
            location = locManager.location!.coordinate
            getCurrentCityWeather(weatherData: WeatherData(lon: location.longitude, lat: location.latitude))
        } else {
            locEnable = false
        }
        
        getActualDate()
        getFirstCityWeather()
        changeStateReloadButton()
        changeStateLocateButton()
    }
}

// MARK: - Labels
extension WeatherViewController {
    
    private func getActualDate() {
        dateLabel.text = Date().dateString()
    }
    
    private func getFirstCityWeather() {
        let nyData = WeatherData(name: "New York")
        WeatherManager().getWeather(location: nyData) { [weak self] data, error in
            if data != nil && error == nil {
                self?.changeFirstCityLabels(data: data!)
                self?.changeStateReloadButton()
            } else {
                self?.showErrorService()
            }
        }
    }
    
    private func getCurrentCityWeather(weatherData: WeatherData) {
        WeatherManager().getWeather(location: weatherData) { [weak self] data, error in
            if data != nil && error == nil {
                self?.changeSecondCityLabels(data: data!)
                if weatherData.status == .validCoord {
                    self?.myLocationCity = (self?.cityNameLabel2.text!)!
                }
                self?.changeStateLocateButton()
                self?.cityTextField.text = ""
            } else {
                self?.showErrorService()
            }
        }
    }
    
    private func changeFirstCityLabels(data: JSONWeather) {
        cityNameLabel1.text = data.name
        tempLabel1.text = "\(Int(data.main.temp))°c"
        descriptionLabel1.text = data.weather.first?.description.capitalized ?? ""
        let min = Int(data.main.temp_min)
        let max = Int(data.main.temp_max)
        minMaxLabel1.text = "\(min)°c / \(max)°c"
    }
    
    private func changeSecondCityLabels(data: JSONWeather) {
        cityNameLabel2.text = data.name
        tempLabel2.text = "\(Int(data.main.temp))°c"
        descriptionLabel2.text = data.weather.first?.description.capitalized ?? ""
        let min = Int(data.main.temp_min)
        let max = Int(data.main.temp_max)
        minMaxLabel2.text = "\(min)°c / \(max)°c"
    }
}

// MARK: - Reload Button
extension WeatherViewController {
    @IBAction func tappedReloadButton(_ sender: UIButton) {
        getFirstCityWeather()
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
    
    @IBAction func tappedLocate(_ sender: UIButton) {
        location = locManager.location!.coordinate
        getCurrentCityWeather(weatherData: WeatherData(lon: location.longitude, lat: location.latitude))
    }
    
    private func changeStateLocateButton() {
        if !locEnable {
            locateButton.isEnabled = false
            locateButton.alpha = 0.3
            locateButton.tintColor = .gray
        } else if cityNameLabel2.text != "-" && cityNameLabel2.text == myLocationCity {
            locateButton.isEnabled = false
            locateButton.alpha = 0.3
            locateButton.tintColor = .blue
        } else {
            locateButton.isEnabled = true
            locateButton.alpha = 1
            locateButton.tintColor = .blue
        }
    }
}

// MARK: - TextField & Keyboard
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        if cityTextField.text != "" {
            getCurrentCityWeather(weatherData: WeatherData(name: cityTextField.text))
        }
        cityTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if cityTextField.text != "" {
            getCurrentCityWeather(weatherData: WeatherData(name: cityTextField.text))
        }
        return textField.resignFirstResponder()
    }
}

// MARK: - Error
extension WeatherViewController {
    private func showErrorService() {
        errorService = true
        errorView.isHidden = !errorService
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.errorService = false
            self.errorView.isHidden = !self.errorService
        }
    }
}
