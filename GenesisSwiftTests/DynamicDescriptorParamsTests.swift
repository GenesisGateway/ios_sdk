//
//  DynamicDescriptorParamsTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import GenesisSwift

class DynamicDescriptorParamsTests: XCTestCase {
    
    var sut: DynamicDescriptorParams!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFullNames() {
        sut = DynamicDescriptorParams(merchantName: "fixed.name", merchantCity: "fixed.city")
        XCTAssertEqual(sut.merchantName, "fixed.name")
        XCTAssertEqual(sut.merchantCity, "fixed.city")
    }
    
    func testOnlyName() {
        sut = DynamicDescriptorParams(merchantName: "fixed.name", merchantCity: nil)
        XCTAssertEqual(sut.merchantName, "fixed.name")
        XCTAssertEqual(sut.merchantCity, nil)
    }
    
    func testOnlyCity() {
        sut = DynamicDescriptorParams(merchantName: nil, merchantCity: "fixed.city")
        XCTAssertEqual(sut.merchantName, nil)
        XCTAssertEqual(sut.merchantCity, "fixed.city")
    }
}
