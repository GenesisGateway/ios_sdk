//
//  HomeViewControllerTests.swift
//  iOSGenesisSampleTests
//

import XCTest
@testable import iOS_Example
@testable import GenesisSwift

final class HomeViewControllerTests: XCTestCase {
    private var controller: HomeTableViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeTableViewController") as? HomeTableViewController
        XCTAssertNotNil(vc)
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
}

// MARK: - Helper Methods
private extension HomeViewControllerTests {

    func segues(ofViewController viewController: UIViewController) -> [String] {
        (viewController.value(forKey: "storyboardSegueTemplates") as? [AnyObject])?
            .compactMap { $0.value(forKey: "identifier") as? String } ?? []
    }
}
