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
    @IBOutlet weak var iconDescription1: UIImageView!
    @IBOutlet weak var minMaxLabel1: UILabel!
    @IBOutlet weak var cityNameLabel2: UILabel!
    @IBOutlet weak var tempLabel2: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!
    @IBOutlet weak var iconDescription2: UIImageView!
    @IBOutlet weak var minMaxLabel2: UILabel!
    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var reloadButton: UIButton!
    
    private var locManager = CLLocationManager()
    private var myLocationCity = ""
    private var locEnable: Bool = false
    private var errorService: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locManager.delegate = self
        
        getActualDate()
        getFirstCityWeather()
        getCurrentCityAtStart()
        //changeStateReloadButton()
        changeStateLocateButton()
    }
}

// MARK: - Service
extension WeatherViewController {
    
    private func getFirstCityWeather() {
        let nyData = WeatherData(name: "New York")
        WeatherManager().getWeather(location: nyData) { [weak self] data, error in
            if data != nil && error == nil {
                self?.changeFirstCityLabels(data: data!)
                self?.changeStateReloadButton()
            } else if let error = error as? APIService.ServiceError {
                if let alertVC = self?.makeAlertVC(message: error.rawValue) {
                    self?.present(alertVC, animated: true, completion: {
                        self?.changeStateReloadButton()
                    })
                }
                //self?.showErrorService()
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
            } else if let error = error as? APIService.ServiceError {
                if let alertVC = self?.makeAlertVC(message: error.rawValue) {
                    self?.present(alertVC, animated: true, completion: nil)
                }
                //self?.showErrorService()
            }
        }
    }
    
    private func getCurrentCityAtStart() {
        guard let location = locManager.location?.coordinate else { return }
        let data = WeatherData(lon: location.longitude, lat: location.latitude)
        getCurrentCityWeather(weatherData: data)
    }
}

// MARK: - Labels
extension WeatherViewController {
    
    private func getActualDate() {
        dateLabel.text = Date().dateString()
    }
    
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
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locManager.requestWhenInUseAuthorization()
        } else {
            guard let location = locManager.location?.coordinate else { return }
            getCurrentCityWeather(weatherData: WeatherData(lon: location.longitude, lat: location.latitude))
        }
    }
    
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
    
    private func makeAlertVC(message: String) -> UIAlertController {
        let alertVC = UIAlertController(title: "Une erreur est survenue", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { alert in
            self.cityTextField.text = ""
        }))
        return alertVC
    }
}

// MARK: - LocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if locManager.location != nil {
            let location = locManager.location!.coordinate
            getCurrentCityWeather(weatherData: WeatherData(lon: location.longitude, lat: location.latitude))
        }
        changeStateLocateButton()
    }
}
