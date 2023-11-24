//
//  TransactionDetailsViewControllerTests.swift
//  iOSGenesisSampleTests
//

import XCTest
@testable import iOS_Example
@testable import GenesisSwift

final class TransactionDetailsViewControllerTests: XCTestCase {
    private var controller: TransactionDetailsViewController!

    override func setUp() {
        super.setUp()
        controller = nil
    }

    override func tearDown() {
        super.tearDown()
        controller = nil
    }
}

extension TransactionDetailsViewControllerTests {

    func testTransactionsDetailsViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TransactionDetailsViewController") as? TransactionDetailsViewController
        XCTAssertNotNil(vc)
        controller = vc
        _ = controller.view
    }
}
