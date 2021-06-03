//
//  DateExtensionTests.swift
//  Travel HelperTests
//
//  Created by Johann Petzold on 03/06/2021.
//

import XCTest
@testable import Travel_Helper

class DateExtensionTests: XCTestCase {

    func testDateString() {
        XCTAssertEqual(Date(timeIntervalSince1970: 1000000000).dateString(), "9 Septembre 2001")
    }

}
