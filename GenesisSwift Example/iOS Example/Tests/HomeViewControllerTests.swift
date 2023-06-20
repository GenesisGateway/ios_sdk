//
//  HomeViewControllerTests.swift
//  iOSGenesisSampleTests
//

import XCTest
@testable import iOS_Example
@testable import GenesisSwift

class HomeViewControllerTests: XCTestCase {
    var controller: HomeTableViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: HomeTableViewController = (storyboard.instantiateViewController(withIdentifier: "HomeTableViewController") as? HomeTableViewController)!
        controller = vc
        _ = controller.view
    }
    
    override func tearDown() {
        super.tearDown()
        
        controller = nil
    }
    
    func testSegues() {
        let identifiers = segues(ofViewController: controller)
        XCTAssertEqual(identifiers.count, 1)
        XCTAssertTrue(identifiers.contains("TransactionDetailsSegue"))
    }
    
    // Mark: - Helper Methods
    
    func segues(ofViewController viewController: UIViewController) -> [String] {
        (viewController.value(forKey: "storyboardSegueTemplates") as? [AnyObject])?
            .compactMap({ $0.value(forKey: "identifier") as? String }) ?? []
    }
}
