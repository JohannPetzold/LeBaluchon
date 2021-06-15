//
//  DateExtension.swift
//  Travel Helper
//
//  Created by Johann Petzold on 02/06/2021.
//

import Foundation

extension Date {
    
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        if Bundle.main.preferredLocalizations.first == "fr" {
            dateFormatter.locale = Locale(identifier: "fr_FR")
        } else {
            dateFormatter.locale = Locale(identifier: "en_US")
        }
        return dateFormatter.string(from: self).capitalized
    }
}
