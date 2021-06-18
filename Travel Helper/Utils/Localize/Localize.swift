//
//  Localize.swift
//  Travel Helper
//
//  Created by Johann Petzold on 14/06/2021.
//

import Foundation

class Localize {
    
    static var errorTitle: String {
        return NSLocalizedString("error_title", comment: "Error Title")
    }
    
    /* Exchange Error */
    static var exchangeError: String {
        return NSLocalizedString("exchange_error", comment: "Exchange Service Error")
    }
    
    static var exchangeErrorNoData: String {
        return NSLocalizedString("exchange_error_no_data", comment: "Exchange Service Error")
    }
    
    static var exchangeErrorDecodeFail: String {
        return NSLocalizedString("exchange_error_decode_fail", comment: "Exchange Service Error")
    }
    
    /* Translate Error */
    static var translateError: String {
        return NSLocalizedString("translate_error", comment: "Translate Service Error")
    }
    
    static var translateErrorNoData: String {
        return NSLocalizedString("translate_error_no_data", comment: "Translate Service Error")
    }
    
    static var translateErrorDecodeFail: String {
        return NSLocalizedString("translate_error_decode_fail", comment: "Translate Service Error")
    }
    
    /* Weather Error */
    static var weatherError: String {
        return NSLocalizedString("weather_error", comment: "Weather Service Error")
    }
    
    static var weatherErrorFirstCity: String {
        return NSLocalizedString("weather_error_first_city", comment: "Weather Service Error")
    }
    
    static var weatherErrorNoData: String {
        return NSLocalizedString("weather_error_no_data", comment: "Weather Service Error")
    }
    
    static var weatherErrorDecodeFail: String {
        return NSLocalizedString("weather_error_decode_fail", comment: "Weather Service Error")
    }
    
    /* Standard Error */
    static var noRequestError: String {
        return NSLocalizedString("error_no_request", comment: "No Request Error")
    }
    
    static var occurredError: String {
        return NSLocalizedString("error_occurred", comment: "Error Occurred")
    }
    
    static var noDataError: String {
        return NSLocalizedString("error_no_data", comment: "No Data Error")
    }
    
    static var badResponseError: String {
        return NSLocalizedString("error_bad_response", comment: "Bad Response Error")
    }
    
    static var decodeFailError: String {
        return NSLocalizedString("error_decode_fail", comment: "Decode Fail Error")
    }
    
    static var buttonClose: String {
        return NSLocalizedString("keyboard_button_close", comment: "Keyboard Close Button")
    }
}
