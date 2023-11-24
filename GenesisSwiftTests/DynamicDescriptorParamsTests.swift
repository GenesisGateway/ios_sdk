//
//  DynamicDescriptorParamsTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import GenesisSwift

final class DynamicDescriptorParamsTests: XCTestCase {

    private var sut: DynamicDescriptorParams!

    func testFullNames() {
        sut = DynamicDescriptorParams(merchantName: "fixed.name", merchantCity: "fixed.city", subMerchantId: nil)
        XCTAssertEqual(sut.merchantName, "fixed.name")
        XCTAssertEqual(sut.merchantCity, "fixed.city")
        XCTAssertNil(sut.subMerchantId)
    }

    func testOnlyName() {
        sut = DynamicDescriptorParams(merchantName: "fixed.name", merchantCity: nil, subMerchantId: nil)
        XCTAssertEqual(sut.merchantName, "fixed.name")
        XCTAssertNil(sut.merchantCity)
        XCTAssertNil(sut.subMerchantId)
    }

    func testOnlyCity() {
        sut = DynamicDescriptorParams(merchantName: nil, merchantCity: "fixed.city", subMerchantId: nil)
        XCTAssertNil(sut.merchantName)
        XCTAssertEqual(sut.merchantCity, "fixed.city")
        XCTAssertNil(sut.subMerchantId)
    }

    func testOnlySubmerchantId() {
        sut = DynamicDescriptorParams(merchantName: nil, merchantCity: nil, subMerchantId: "fixed.id")
        XCTAssertNil(sut.merchantName)
        XCTAssertNil(sut.merchantCity)
        XCTAssertEqual(sut.subMerchantId, "fixed.id")
    }
}
