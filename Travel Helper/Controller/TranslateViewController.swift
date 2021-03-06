//
//  TranslateViewController.swift
//  Travel Helper
//
//  Created by Johann Petzold on 20/05/2021.
//

import UIKit

class TranslateViewController: MainViewController {

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
        
        keyboardDivideValue = 4
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
    
    /* Get translation from the API
     If error, present the AlertController */
    private func getTranslation() {
        showActivityIndicator()
        manager.getTranslation { [weak self] translation, error in
            guard let self = self else { return }
            if translation != nil && error == nil {
                self.targetLabel.text = translation!
                self.hideActivityIndicator()
            } else if let error = error as? ServiceError {
                var errorMessage: String
                switch error {
                case .noData: errorMessage = Localize.translateErrorNoData
                case .decodeFail: errorMessage = Localize.translateErrorDecodeFail
                default: errorMessage = Localize.translateError
                }
                let alertVC = self.makeAlertVC(message: errorMessage)
                self.present(alertVC, animated: true, completion: {
                    self.hideActivityIndicator()
                })
            }
        }
    }
}

// MARK: - Detect
extension TranslateViewController {
    
    /* Get the lang detection from the API and modify the source and target */
    private func getDetection(text: String) {
        if text != "" {
            detectManager.detectData.text = text
            detectManager.getDetection { [weak self] lang, error in
                guard let self = self else { return }
                if lang != nil && error == nil {
                    if (lang == "fr" && self.manager.translateData.source == "en") || (lang == "en" && self.manager.translateData.source == "fr") {
                        self.swapSourceTarget()
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
    
    /* Swap source and target datas and images */
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
}

// MARK: - TextField
extension TranslateViewController: UITextFieldDelegate {
    
    /* Get Translation on return */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil && textField.text != "" {
            manager.translateData.text = textField.text
            getTranslation()
        }
        return textField.resignFirstResponder()
    }
    
    /* Get detection on change if activated */
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
