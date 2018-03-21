//
//  PaymentTransactionTypeTest.swift
//  GenesisWebViewTests
//

import XCTest
@testable import GenesisSwift

class PaymentTransactionTypeTest: XCTestCase {
    
    var sut: PaymentTransactionType!

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProperties() {
        let transactionName = TransactionName(rawValue: "sale")!
        sut = PaymentTransactionType(name: transactionName)
        
        XCTAssertEqual(sut.name, TransactionName.sale)
    }
}
