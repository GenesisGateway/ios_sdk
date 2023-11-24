//
//  PaymentTransactionTypeTest.swift
//  GenesisWebViewTests
//

import XCTest
@testable import GenesisSwift

final class PaymentTransactionTypeTest: XCTestCase {

    private var sut: PaymentTransactionType!

    func testProperties() {
        let transactionName = TransactionName(rawValue: "sale")!
        sut = PaymentTransactionType(name: transactionName)

        XCTAssertEqual(sut.name, .sale)
    }
}
