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
    @IBOutlet weak var errorServiceView: UIView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var serviceActivityIndicator: UIActivityIndicatorView!
    
    private var manager = TranslateManager()
    private var errorService: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            if let error = error as? APIService.ServiceError {
                if let alertVC = self?.makeAlertVC(message: error.rawValue) {
                    self?.present(alertVC, animated: true, completion: {
                        self?.hideActivityIndicator()
                    })
                }
                //self?.showErrorService()
            }
        }
    }
}

// MARK: - Flags Data & Action
extension TranslateViewController {
    private func initTranslateData() {
        manager.translateData.source = "fr"
        manager.translateData.target = "en"
    }
    
    @IBAction func tappedSwapButton(_ sender: UIButton) {
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
}

// MARK: - Keyboard
extension TranslateViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        sourceTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil && textField.text != "" {
            manager.translateData.text = textField.text
            getTranslation()
        }
        return textField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        targetLabel.text = ""
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
    private func showErrorService() {
        errorService = true
        errorServiceView.isHidden = !errorService
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.errorService = false
            self.errorServiceView.isHidden = !self.errorService
        }
    }
    
    private func makeAlertVC(message: String) -> UIAlertController {
        let alertVC = UIAlertController(title: "Une erreur est survenue", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertVC
    }
}

//func getFlag() -> String {
//        let base: UInt32 = UnicodeScalar("🇦").value - UnicodeScalar("A").value
//
//        return String(String.UnicodeScalarView(
//            countryCode.unicodeScalars.compactMap({ UnicodeScalar(base + $0.value) })
//        ))
//    }
