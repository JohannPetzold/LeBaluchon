//
//  ExchangeViewController.swift
//  Travel Helper
//
//  Created by Johann Petzold on 20/05/2021.
//

import UIKit

class ExchangeViewController: MainViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountPickerView: UIPickerView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultPickerView: UIPickerView!
    @IBOutlet weak var reloadButton: UIButton!
    
    private var resultData = Currencies.allCases
    private var exchange = ExchangeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addButtonToKeyboard()
        addKeyboardObservers()
        getService()
        updateResultData()
    }
}

// MARK: - Service
extension ExchangeViewController {
    
    /* Get data needed from the API
     If an error occurred, present the AlertController */
    private func getService() {
        exchange.getExchange { [weak self] success, error in
            guard let self = self else { return }
            if success {
                self.showErrorButton(false)
                if self.amountTextField.text != "" {
                    self.exchangeCurrency()
                }
            }
            if let error = error as? ServiceError {
                var errorMessage: String
                switch error {
                case .decodeFail: errorMessage = Localize.exchangeErrorDecodeFail
                case .noData: errorMessage = Localize.exchangeErrorNoData
                default: errorMessage = Localize.exchangeError
                }
                let alertVC = self.makeAlertVC(message: errorMessage)
                self.present(alertVC, animated: true, completion: nil)
                self.showErrorButton(true)
            }
        }
    }
}

// MARK: - Exchange
extension ExchangeViewController {
    
    /* Do the math with parameters needed for swapCurrencies method and display it */
    private func exchangeCurrency() {
        guard let text = amountTextField.text else { return }
        guard let amount = Double(text) else { resultLabel.text = ""; return }
        let source = getCurrencyFromPicker(amountPickerView)!
        let target = getCurrencyFromPicker(resultPickerView)!
        exchange.swapCurrencies(amount: amount, source: source, target: target) { result in
            resultLabel.text = String(format: "%.2f", result)
        }
    }
    
    /* Return the selected Currencies from the PickerView in parameter */
    private func getCurrencyFromPicker(_ picker: UIPickerView) -> Currencies? {
        if picker == amountPickerView {
            return Currencies.allCases[amountPickerView.selectedRow(inComponent: 0)]
        } else if picker == resultPickerView {
            return Currencies.allCases[Currencies.allCases.firstIndex(of: resultData[resultPickerView.selectedRow(inComponent: 0)])!]
        }
        return nil
    }
}

// MARK: - Picker Currencies
extension ExchangeViewController {
    
    @IBAction func tappedSwapCurrencies(_ sender: UIButton) {
        swapPickerCurrencies()
        exchangeCurrency()
    }
    
    /* Swap pickers selectRow and ResultPicker datas*/
    private func swapPickerCurrencies() {
        let amountIndex = amountPickerView.selectedRow(inComponent: 0)
        let resultIndex = Currencies.allCases.firstIndex(of: resultData[resultPickerView.selectedRow(inComponent: 0)])!
        
        amountPickerView.selectRow(resultIndex, inComponent: 0, animated: true)
        updateResultData()
        
        let updateAmountIndex = resultData.firstIndex(of: Currencies.allCases[amountIndex])!
        resultPickerView.reloadComponent(0)
        resultPickerView.selectRow(updateAmountIndex, inComponent: 0, animated: true)
    }
    
    /* Get Currencies minus the one from the amountPickerView */
    private func updateResultData() {
        resultData = Currencies.allCases.filter({ currency in
            return currency != getCurrencyFromPicker(amountPickerView)
        })
    }
    
    private func reloadResultPicker() {
        updateResultData()
        resultPickerView.reloadComponent(0)
        resultPickerView.selectRow(0, inComponent: 0, animated: true)
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
        if amountTextField.text != nil && amountTextField.text != "" {
            exchangeCurrency()
        }
    }
}

// MARK: - TextField
extension ExchangeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return amountTextField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        exchangeCurrency()
    }
    
    /* Stop the textField editing if wrong value are entered
     Conform to a number representation with 2 digits */
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

// MARK: - Keyboard
extension ExchangeViewController {
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
    }
    
    /* Add a ToolBar on Keyboard with a Close button */
    private func addButtonToKeyboard() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: Localize.buttonClose, style: UIBarButtonItem.Style.done, target: textField, action: #selector(hideKeyboard))
        ]
        toolbar.sizeToFit()
        amountTextField.inputAccessoryView = toolbar
    }
    
    @objc func hideKeyboard() {
        amountTextField.resignFirstResponder()
    }
}

// MARK: - Error
extension ExchangeViewController {
    
    @IBAction func tappedRetryService(_ sender: UIButton) {
        getService()
    }
    
    private func showErrorButton(_ show: Bool) {
        reloadButton.isHidden = !show
    }
}
