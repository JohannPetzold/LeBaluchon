//
//  DetectData.swift
//  Travel Helper
//
//  Created by Johann Petzold on 10/06/2021.
//

import Foundation

class DetectData {
    
    var text: String?
    
    init(text: String? = nil) {
        self.text = text
    }
    
    enum DataStatus {
        case valid
        case invalid
    }
    
    var status: DataStatus {
        if text != nil {
            return .valid
        } else {
            return .invalid
        }
    }
}
