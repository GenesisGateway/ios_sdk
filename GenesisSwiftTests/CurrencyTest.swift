//
//  CurrencyTest.swift
//  GenesisWebViewTests
//

import XCTest
@testable import GenesisSwift

class CurrencyTest: XCTestCase {
    
    var sut: Currency!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        XCTAssertEqual(Currencies.find(key: "USD"), .USD)
        XCTAssertEqual(Currencies.convertToMinor(fromAmount: 1000.001, andCurrency: .KWD), "1000001")
        XCTAssertEqual(Currencies.convertToMinor(fromAmount: 1234.567, andCurrency: .USD), "123456")
        XCTAssertNotEqual(Currencies.convertToMinor(fromAmount: 1234.567, andCurrency: .JPY), "1234567")
        XCTAssertEqual(Currencies.convertToMinor(fromAmount: 1234.567, andCurrency: .JPY), "1234")
        
        let decimal1 = Currencies.convertToDecimal(fromMinorString: "123456", andCurrency: .USD)
        let double1 = NSDecimalNumber(decimal: decimal1!).doubleValue
        XCTAssertEqual(double1, 1234.56, accuracy: 0.000001)
        
        let decimal2 = Currencies.convertToDecimal(fromMinorString: "123456", andCurrency: .JPY)
        let double2 = NSDecimalNumber(decimal: decimal2!).doubleValue
        XCTAssertEqual(double2, 123456, accuracy: 0.000001)
    }
}
