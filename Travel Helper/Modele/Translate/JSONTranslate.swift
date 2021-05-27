//
//  JSONTranslate.swift
//  Travel Helper
//
//  Created by Johann Petzold on 25/05/2021.
//

import Foundation

struct JSONTranslate: Decodable {
    var data: Translations
}

struct Translations: Decodable {
    var translations: [TranslatedText]
}

struct TranslatedText: Decodable {
    var translatedText: String
}
