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
        dateFormatter.locale = Locale(identifier: "fr_FR")
        return dateFormatter.string(from: self).capitalized
    }
}
