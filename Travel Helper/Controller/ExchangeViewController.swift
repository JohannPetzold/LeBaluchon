//
//  ExchangeViewController.swift
//  Travel Helper
//
//  Created by Johann Petzold on 20/05/2021.
//

import UIKit

class ExchangeViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountPickerView: UIPickerView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultPickerView: UIPickerView!
    @IBOutlet weak var errorServiceView: UIView!
    
    private var resultData = Currencies.allCases
    private var exchange = ExchangeManager()
    private var errorService: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ExchangeService.shared.getExchange { jsonExchange, error in
            if jsonExchange != nil, error == nil {
                self.exchange.updateExchange(exchangeData: jsonExchange!)
            }
            if error != nil {
                self.errorService = true
                self.showErrorService()
            }
        }
        updateResultData()
    }
}

// MARK: - Exchange
extension ExchangeViewController {
    @IBAction func tappedSwapCurrencies(_ sender: UIButton) {
        swapPickerCurrencies()
        exchangeCurrency()
    }
    
    private func updateResultData() {
        resultData = Currencies.allCases.filter({ currency in
            return currency != Currencies.allCases[amountPickerView.selectedRow(inComponent: 0)]
        })
    }
    
    private func reloadResultPicker() {
        updateResultData()
        resultPickerView.reloadComponent(0)
        resultPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    private func swapPickerCurrencies() {
        let amountIndex = amountPickerView.selectedRow(inComponent: 0)
        let resultIndex = Currencies.allCases.firstIndex(of: resultData[resultPickerView.selectedRow(inComponent: 0)])!
        
        amountPickerView.selectRow(resultIndex, inComponent: 0, animated: true)
        updateResultData()
        
        let updateAmountIndex = resultData.firstIndex(of: Currencies.allCases[amountIndex])!
        resultPickerView.reloadComponent(0)
        resultPickerView.selectRow(updateAmountIndex, inComponent: 0, animated: true)
    }
    
    private func getCurrencyFromPicker(tag: Int) -> Currencies? {
        if tag == 0 {
            return Currencies.allCases[amountPickerView.selectedRow(inComponent: 0)]
        } else if tag == 1 {
            return Currencies.allCases[Currencies.allCases.firstIndex(of: resultData[resultPickerView.selectedRow(inComponent: 0)])!]
        }
        return nil
    }
    
    private func exchangeCurrency() {
        guard let text = amountTextField.text else { return }
        guard let amount = Double(text) else { resultLabel.text = ""; return }
        let currency = getCurrencyFromPicker(tag: amountPickerView.tag)!
        let target = getCurrencyFromPicker(tag: resultPickerView.tag)!
        exchange.swapCurrencies(amount: amount, currency: currency, target: target) { result in
            resultLabel.text = String(format: "%.2f", result)
        }
    }
}

// MARK: - PickerView
extension ExchangeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == amountPickerView {
            return Currencies.allCases.count
        }
        return resultData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == amountPickerView {
            return Currencies.allCases[row].rawValue
        }
        return resultData[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == amountPickerView {
            reloadResultPicker()
        }
        if amountTextField.text != nil {
            exchangeCurrency()
        }
    }
}

// MARK: - Keyboard & TextField
extension ExchangeViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return amountTextField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        exchangeCurrency()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        
        if (textField.text?.contains("."))! && string == "." {
            return false
        }
        
        if (textField.text?.contains("."))! {
            let limitDecimalPlace = 2
            let decimalPlace = textField.text?.components(separatedBy: ".").last
            if (decimalPlace?.count)! < limitDecimalPlace {
                return true
            }
            else {
                return false
            }
        }
        return true
    }
}

// MARK: - Error
extension ExchangeViewController {
    @IBAction func tappedRetryService(_ sender: UIButton) {
        ExchangeService.shared.getExchange { jsonExchange, error in
            if jsonExchange != nil, error == nil {
                self.exchange.updateExchange(exchangeData: jsonExchange!)
                self.errorService = false
                self.showErrorService()
            }
        }
    }
    
    private func showErrorService() {
        errorServiceView.isHidden = !errorService
    }
}
