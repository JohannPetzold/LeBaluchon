//
//  MainViewController.swift
//  Travel Helper
//
//  Created by Johann Petzold on 17/06/2021.
//

import UIKit

class MainViewController: UIViewController {

    var keyboardDivideValue: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
    }

    /* Add Observers to modify the view when keyboard appear or disappear */
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height / keyboardDivideValue
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, view.frame.origin.y != 0 {
            self.view.frame.origin.y += keyboardSize.height / keyboardDivideValue
        }
    }
    
    /* Return an UIAlertController with the Localize error title and a unique OK button */
    func makeAlertVC(message: String) -> UIAlertController {
        let alertVC = UIAlertController(title: Localize.errorTitle, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertVC
    }
}
