//
//  TranslateData.swift
//  Travel Helper
//
//  Created by Johann Petzold on 26/05/2021.
//

import Foundation

class TranslateData {
    var text: String?
    var source: String?
    var target: String?
    
    init(text: String? = nil, source: String? = nil, target: String? = nil) {
        self.text = text
        self.source = source
        self.target = target
    }
    
    enum DataStatus {
        case valid
        case invalid
    }
    
    var status: DataStatus {
        if text != nil && source != nil && target != nil && source != target {
            return .valid
        } else {
            return .invalid
        }
    }
}

enum Language: String {
    case fr = "fr"
    case en = "en"
}
