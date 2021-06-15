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
    @IBOutlet weak var reloadButton: UIButton!
    
    private var resultData = Currencies.allCases
    private var exchange = ExchangeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addButtonToKeyboard(title: Localize.buttonClose)
        addKeyboardObservers()
        getService()
        updateResultData()
    }
}

// MARK: - Service
extension ExchangeViewController {
    
    private func getService() {
        exchange.getExchange { [weak self] success, error in
            guard let self = self else { return }
            if success {
                self.showErrorButton(false)
                if self.amountTextField.text != "" {
                    self.exchangeCurrency()
                }
            }
            if error != nil {
                let alertVC = self.makeAlertVC(message: Localize.exchangeError)
                self.present(alertVC, animated: true, completion: nil)
                self.showErrorButton(true)
            }
        }
    }
}

// MARK: - Exchange
extension ExchangeViewController {
    
    @IBAction func tappedSwapCurrencies(_ sender: UIButton) {
        swapPickerCurrencies()
        exchangeCurrency()
    }
    
    /* resultData contient toutes les devises sauf celle choisie dans le premier picker */
    private func updateResultData() {
        resultData = Currencies.allCases.filter({ currency in
            return currency != getCurrencyFromPicker(amountPickerView)
        })
    }
    
    /* Réinitialise l'affichage du resultPicker */
    private func reloadResultPicker() {
        updateResultData()
        resultPickerView.reloadComponent(0)
        resultPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    /* Echange les données des deux PickerView en respectant les index */
    private func swapPickerCurrencies() {
        let amountIndex = amountPickerView.selectedRow(inComponent: 0)
        let resultIndex = Currencies.allCases.firstIndex(of: resultData[resultPickerView.selectedRow(inComponent: 0)])!
        
        amountPickerView.selectRow(resultIndex, inComponent: 0, animated: true)
        updateResultData()
        
        let updateAmountIndex = resultData.firstIndex(of: Currencies.allCases[amountIndex])!
        resultPickerView.reloadComponent(0)
        resultPickerView.selectRow(updateAmountIndex, inComponent: 0, animated: true)
    }
    
    private func getCurrencyFromPicker(_ picker: UIPickerView) -> Currencies? {
        if picker == amountPickerView {
            return Currencies.allCases[amountPickerView.selectedRow(inComponent: 0)]
        } else if picker == resultPickerView {
            return Currencies.allCases[Currencies.allCases.firstIndex(of: resultData[resultPickerView.selectedRow(inComponent: 0)])!]
        }
        return nil
    }
    
    private func exchangeCurrency() {
        guard let text = amountTextField.text else { return }
        guard let amount = Double(text) else { resultLabel.text = ""; return }
        let source = getCurrencyFromPicker(amountPickerView)!
        let target = getCurrencyFromPicker(resultPickerView)!
        exchange.swapCurrencies(amount: amount, source: source, target: target) { result in
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
        if amountTextField.text != nil && amountTextField.text != "" {
            exchangeCurrency()
        }
    }
}

// MARK: - TextField & Keyboard
extension ExchangeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return amountTextField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        exchangeCurrency()
    }
    
    /* Limite l'entrée de l'utilisateur à 1 . et 2 décimales */
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
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
    }
    
    private func addButtonToKeyboard(title: String) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: title, style: UIBarButtonItem.Style.done, target: textField, action: #selector(hideKeyboard))
        ]
        toolbar.sizeToFit()
        amountTextField.inputAccessoryView = toolbar
    }
    
    @objc func hideKeyboard() {
        amountTextField.resignFirstResponder()
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height / 2
        }
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, view.frame.origin.y != 0 {
            self.view.frame.origin.y += keyboardSize.height / 2
        }
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
    
    private func makeAlertVC(message: String) -> UIAlertController {
        let alertVC = UIAlertController(title: Localize.errorTitle, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertVC
    }
}
