//
//  TranslateViewController.swift
//  Travel Helper
//
//  Created by Johann Petzold on 20/05/2021.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet weak var sourceFlag: UIImageView!
    @IBOutlet weak var targetFlag: UIImageView!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var serviceActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var detectSwitch: UISwitch!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var swapButton2: UIButton!
    @IBOutlet weak var detectLabel: UILabel!
    
    private var manager = TranslateManager()
    private var detectManager = DetectManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardObservers()
        initTranslateData()
        serviceActivityIndicator.stopAnimating()
    }
}

// MARK: - Translate
extension TranslateViewController {
    
    @IBAction func tappedTranslateButton(_ sender: UIButton) {
        guard let text = sourceTextField.text else { return }
        manager.translateData.text = text
        getTranslation()
    }
    
    private func getTranslation() {
        showActivityIndicator()
        manager.getTranslation { [weak self] translation, error in
            if translation != nil && error == nil {
                self?.targetLabel.text = translation!
                self?.hideActivityIndicator()
            }
            if error != nil {
                if let alertVC = self?.makeAlertVC(message: Localize.translateError) {
                    self?.present(alertVC, animated: true, completion: {
                        self?.hideActivityIndicator()
                    })
                }
            }
        }
    }
}

// MARK: - Detect
extension TranslateViewController {
    
    private func getDetection(text: String) {
        if text != "" {
            detectManager.detectData.text = text
            detectManager.getDetection { [weak self] lang, error in
                if lang != nil && error == nil {
                    if (lang == "fr" && self?.manager.translateData.source == "en") || (lang == "en" && self?.manager.translateData.source == "fr") {
                        self?.swapSourceTarget()
                    }
                }
            }
        }
    }
    
    @IBAction func tappedDetectSwitch(_ sender: UISwitch) {
        modifySwapButtonState()
    }
}

// MARK: - Flags Data & Action
extension TranslateViewController {
    
    private func initTranslateData() {
        manager.translateData.source = "fr"
        manager.translateData.target = "en"
    }
    
    @IBAction func tappedSwapButton(_ sender: UIButton) {
        swapSourceTarget()
    }
    
    private func swapSourceTarget() {
        if manager.translateData.source == "fr" {
            sourceFlag.image = UIImage(named: "en")
            targetFlag.image = UIImage(named: "fr")
            manager.translateData.source = "en"
            manager.translateData.target = "fr"
        } else if manager.translateData.source == "en" {
            sourceFlag.image = UIImage(named: "fr")
            targetFlag.image = UIImage(named: "en")
            manager.translateData.source = "fr"
            manager.translateData.target = "en"
        }
        if sourceTextField.text != nil && sourceTextField.text != "" && targetLabel.text != "" {
            let tempText = sourceTextField.text!
            sourceTextField.text = targetLabel.text
            targetLabel.text = tempText
        }
    }
    
    private func modifySwapButtonState() {
        if detectSwitch.isOn {
            swapButton.isEnabled = false
            swapButton2.isEnabled = false
        } else {
            swapButton.isEnabled = true
            swapButton2.isEnabled = true
        }
    }
}
// MARK: - Keyboard
extension TranslateViewController {
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        sourceTextField.resignFirstResponder()
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height / 4
        }
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, view.frame.origin.y != 0 {
            self.view.frame.origin.y += keyboardSize.height / 4
        }
    }
}

// MARK: - TextField
extension TranslateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil && textField.text != "" {
            manager.translateData.text = textField.text
            getTranslation()
        }
        return textField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text != "" && detectSwitch.isOn {
            getDetection(text: textField.text!)
        }
        if targetLabel.text != "" {
            targetLabel.text = ""
        }
    }
}

// MARK: - ActivityIndicator
extension TranslateViewController {
    
    private func showActivityIndicator() {
        serviceActivityIndicator.startAnimating()
        translateButton.isHidden = true
    }
    
    private func hideActivityIndicator() {
        serviceActivityIndicator.stopAnimating()
        translateButton.isHidden = false
    }
}

// MARK: - Error
extension TranslateViewController {
    
    private func makeAlertVC(message: String) -> UIAlertController {
        let alertVC = UIAlertController(title: Localize.errorTitle, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertVC
    }
}
