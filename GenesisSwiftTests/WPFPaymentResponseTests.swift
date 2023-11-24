//
//  WPFPaymentResponseTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import GenesisSwift

final class WPFPaymentResponseTests: XCTestCase {

    var sut: WPFResponse!
    var xmlString: String!

    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "XMLRespose", withExtension: "xml") else {
            XCTFail("XMLRespose.xml not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            xmlString = String(data: data, encoding: .utf8)
        } catch {
            XCTFail("initilization failure \(error.localizedDescription)")
        }
    }
}

extension WPFPaymentResponseTests {

    func testProperties() {
        sut = WPFResponse(xmlString: xmlString)

        XCTAssertEqual(sut.amount, 5000)
        XCTAssertEqual(sut.currency, "USD")
        XCTAssertEqual(sut.status, .new)
        XCTAssertEqual(sut.uniqueId, "id1234")
        XCTAssertEqual(sut.transactionId, "transactionID")
        XCTAssertEqual(sut.timestamp, "2017-10-23T12:51:39Z".dateFromISO8601)
        XCTAssertEqual(sut.redirectUrl, "https://redirect.url")
    }
}
