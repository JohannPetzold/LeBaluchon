//
//  JSONDetect.swift
//  Travel Helper
//
//  Created by Johann Petzold on 10/06/2021.
//

import Foundation

struct JSONDetect: Decodable {
    var data: Detections
}

struct Detections: Decodable {
    var detections: [[DetectedLanguage]]
}

struct DetectedLanguage: Decodable {
    var language: String
}
