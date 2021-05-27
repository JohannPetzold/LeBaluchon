//
//  TranslateViewController.swift
//  Travel Helper
//
//  Created by Johann Petzold on 20/05/2021.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet var sourceFlags: [UIButton]!
    @IBOutlet var targetFlags: [UIButton]!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var errorServiceView: UIView!
        
    private var data = TranslateData()
    private var errorService: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Translate
extension TranslateViewController {
    @IBAction func tappedTranslateButton(_ sender: UIButton) {
        guard let text = sourceTextField.text else { return }
        data.text = text
        getTranslation()
    }
    
    private func getTranslation() {
        TranslateService.shared.translate(data: data) { translation, error in
            if translation != nil && error == nil {
                self.targetLabel.text = translation!
            }
            if error != nil {
                self.showErrorService()
            }
        }
    }
}

// MARK: - Flags Data & Action
extension TranslateViewController {
    private func modifyFlagsState(flags: [UIButton], choice: String) {
        for flag in flags {
            if flag.currentTitle == choice && !flag.isSelected {
                flag.isSelected = true
                flag.alpha = 1
                modifyTranslateData(flags: flags, choice: choice)
            } else {
                flag.isSelected = false
                flag.alpha = 0.5
            }
        }
    }
    
    private func modifyTranslateData(flags: [UIButton], choice: String) {
        if flags == sourceFlags {
            data.source = choice
        }
        if flags == targetFlags {
            data.target = choice
        }
    }
    
    @IBAction func tappedSourceFlagButton(_ sender: UIButton) {
        modifyFlagsState(flags: sourceFlags, choice: sender.currentTitle!)
    }
    
    @IBAction func tappedTargetFlagButton(_ sender: UIButton) {
        modifyFlagsState(flags: targetFlags, choice: sender.currentTitle!)
    }
}

// MARK: - Keyboard
extension TranslateViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        sourceTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil && textField.text != "" {
            data.text = textField.text
            getTranslation()
        }
        return textField.resignFirstResponder()
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
}
