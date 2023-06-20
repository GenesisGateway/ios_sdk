//
//  TransactionDetailsViewControllerTests.swift
//  iOSGenesisSampleTests
//

import XCTest
@testable import iOS_Example
@testable import GenesisSwift

class TransactionDetailsViewControllerTests: XCTestCase {
    var controller: TransactionDetailsViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: TransactionDetailsViewController = (storyboard.instantiateViewController(withIdentifier: "TransactionDetailsViewController") as? TransactionDetailsViewController)!
        controller = vc
        _ = controller.view
    }
    
    override func tearDown() {
        super.tearDown()
        
        controller = nil
    }
}
