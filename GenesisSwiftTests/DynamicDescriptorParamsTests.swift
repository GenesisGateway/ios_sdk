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
        sut = DynamicDescriptorParams(merchantName: "fixed.name", merchantCity: "fixed.city", subMerchantId: nil)
        XCTAssertEqual(sut.merchantName, "fixed.name")
        XCTAssertEqual(sut.merchantCity, "fixed.city")
        XCTAssertEqual(sut.subMerchantId, nil)
    }
    
    func testOnlyName() {
        sut = DynamicDescriptorParams(merchantName: "fixed.name", merchantCity: nil, subMerchantId: nil)
        XCTAssertEqual(sut.merchantName, "fixed.name")
        XCTAssertEqual(sut.merchantCity, nil)
        XCTAssertEqual(sut.subMerchantId, nil)
    }
    
    func testOnlyCity() {
        sut = DynamicDescriptorParams(merchantName: nil, merchantCity: "fixed.city", subMerchantId: nil)
        XCTAssertEqual(sut.merchantName, nil)
        XCTAssertEqual(sut.merchantCity, "fixed.city")
        XCTAssertEqual(sut.subMerchantId, nil)
    }

    func testOnlySubmerchantId() {
        sut = DynamicDescriptorParams(merchantName: nil, merchantCity: nil, subMerchantId: "fixed.id")
        XCTAssertEqual(sut.merchantName, nil)
        XCTAssertEqual(sut.merchantCity, nil)
        XCTAssertEqual(sut.subMerchantId, "fixed.id")
    }
}
