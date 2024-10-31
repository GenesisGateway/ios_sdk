//
//  DynamicDescriptorParamsTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import GenesisSwift

final class DynamicDescriptorParamsTests: XCTestCase {
}

// MARK: - Tests

extension DynamicDescriptorParamsTests {

    func testFullNames() {
        let params = DynamicDescriptorParams(merchantName: "fixed.name", merchantCity: "fixed.city", subMerchantId: nil)
        XCTAssertEqual(params.merchantName, "fixed.name")
        XCTAssertEqual(params.merchantCity, "fixed.city")
        XCTAssertNil(params.subMerchantId)
    }

    func testOnlyName() {
        let params = DynamicDescriptorParams(merchantName: "fixed.name", merchantCity: nil, subMerchantId: nil)
        XCTAssertEqual(params.merchantName, "fixed.name")
        XCTAssertNil(params.merchantCity)
        XCTAssertNil(params.subMerchantId)
    }

    func testOnlyCity() {
        let params = DynamicDescriptorParams(merchantName: nil, merchantCity: "fixed.city", subMerchantId: nil)
        XCTAssertNil(params.merchantName)
        XCTAssertEqual(params.merchantCity, "fixed.city")
        XCTAssertNil(params.subMerchantId)
    }

    func testOnlySubmerchantId() {
        let params = DynamicDescriptorParams(merchantName: nil, merchantCity: nil, subMerchantId: "fixed.id")
        XCTAssertNil(params.merchantName)
        XCTAssertNil(params.merchantCity)
        XCTAssertEqual(params.subMerchantId, "fixed.id")
    }

    func testAllParameters() {
        let params = DynamicDescriptorParams(merchantName: "John Doe",
                                             merchantCity: "Dallas",
                                             merchantCountry: "US",
                                             merchantState: "TX",
                                             merchantZipCode: "1024",
                                             merchantAddress: "High Str. 1",
                                             merchantUrl: "https://google.com",
                                             merchantPhone: "1-555-01234",
                                             merchantServiceCity: "Austin",
                                             merchantServiceCountry: "US",
                                             merchantServiceState: "TX",
                                             merchantServiceZipCode: "1023",
                                             merchantServicePhone: "1-555-12345",
                                             subMerchantId: "12345",
                                             merchantGeoCoordinates: "40.73061,-73.93524",
                                             merchantServiceGeoCoordinates: "40.73061,-73.93524")
        let xml = params.description()

        for (key, tagValue) in params.propertyMap() {
            if let paramValue = params[key] as? String {
                XCTAssertEqual(paramValue, Utils.xmlValue(inTag: tagValue, from: xml))
            } else {
                XCTFail("Missing dynamic param value for tag: \(tagValue)")
            }
        }
    }
}
