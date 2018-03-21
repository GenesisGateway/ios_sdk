//
//  StringTests.swift
//  GenesisSwiftTests
//

import XCTest
@testable import GenesisSwift

class StringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConvertionToDecimal() {
        var decimal = "123,123.12".explicitConvertionToDecimal()
        XCTAssertNotNil(decimal)
        XCTAssertEqual(decimal, 123123.12)
        
        decimal = "3,123.12".explicitConvertionToDecimal()
        XCTAssertEqual(decimal, 3123.12)
        
        decimal = "1234.1".explicitConvertionToDecimal()
        XCTAssertEqual(decimal, 1234.1)
        
        decimal = "123456789".explicitConvertionToDecimal()
        XCTAssertEqual(decimal, 123456789)
        
        decimal = "123,123,123.12".explicitConvertionToDecimal()
        XCTAssertEqual(decimal, 123123123.12)
        
        decimal = "0".explicitConvertionToDecimal()
        XCTAssertEqual(decimal, 0)
        
        decimal = "1".explicitConvertionToDecimal()
        XCTAssertEqual(decimal, 1)
        
        decimal = "-1".explicitConvertionToDecimal()
        XCTAssertEqual(decimal, -1)
        
        decimal = "-10.11".explicitConvertionToDecimal()
        XCTAssertEqual(decimal, -10.11)
        
        decimal = "12.123".explicitConvertionToDecimal()
        XCTAssertEqual(decimal, 12.123)
        
        decimal = "0.99999".explicitConvertionToDecimal()
        XCTAssertEqual(decimal, 0.99999)
        
        decimal = "-0.99999".explicitConvertionToDecimal()
        XCTAssertEqual(decimal, -0.99999)
    }
}
