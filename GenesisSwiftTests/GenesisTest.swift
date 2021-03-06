//
//  GenesisTest.swift
//  GenesisSwiftTests
//

import XCTest
@testable import GenesisSwift

class GenesisTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func genesis() -> Genesis {
        let paymentAddress = PaymentAddress(firstName: "firstName",
                                               lastName: "lastName",
                                               address1: "address1",
                                               address2: "address2",
                                               zipCode: "zipCode",
                                               city: "city",
                                               state: "st",
                                               country: IsoCountryCodes.search(byName: "United States"))

        let paymentRequest = PaymentRequest(transactionId: "transactionId",
                                               amount: 1,
                                               currency: Currencies().USD,
                                               customerEmail: "customerEmail@email.com",
                                               customerPhone: "1234567",
                                               billingAddress: paymentAddress,
                                               transactionTypes: [PaymentTransactionType(name: .sale)],
                                               notificationUrl: "https://example.com/notification")
        
        let credentials = Credentials(withUsername: "Username", andPassword: "Password")
        
        let configuration = Configuration(credentials: credentials, language: .en, environment: .staging, endpoint: .emerchantpay)
        
        let genesis = Genesis(withConfiguration: configuration, paymentRequest: paymentRequest, forDelegate: self)
        
        return genesis
    }
    
    func testGenesis() {
        let genesis = self.genesis()
        
        XCTAssertNotNil(genesis.configuration)
        XCTAssertNotNil(genesis.paymentRequest)
        XCTAssertNotNil(genesis.delegate)
        XCTAssertNil(genesis.genesisWebView)

        let vc = genesis.genesisViewController()
        XCTAssertNotNil(vc)
        XCTAssertNotNil(genesis.genesisVC)
        XCTAssertNotNil(genesis.genesisWebView)
        
        XCTAssertNotNil(genesis.genesisWebViewWithConfiguration())
        
        XCTAssertFalse(genesis.animatedBack)
    }
    
    func testShow() {
        let genesis = self.genesis()

        genesis.present(toViewController: UIViewController(), animated: true)
        
        XCTAssertTrue(genesis.animatedBack)
        
        genesis.back(animated: true)
        
        genesis.push(toNavigationController: UINavigationController(), animated: false)
        
        XCTAssertFalse(genesis.animatedBack)
        
        genesis.back(animated: false)
    }
    
    func testAllRequiredPropertiesAreSetted() {
        var genesis = self.genesis()
        XCTAssertTrue(genesis.allRequiredPropertiesAreSetted())

        genesis.configuration = nil
        
        XCTAssertNil(genesis.genesisWebViewWithConfiguration())
        XCTAssertFalse(genesis.allRequiredPropertiesAreSetted())

        genesis = self.genesis()
        
        genesis.paymentRequest = nil
        XCTAssertFalse(genesis.allRequiredPropertiesAreSetted())
    }
    
}

// MARK: - GenesisDelegate
extension GenesisTest: GenesisDelegate {
    
    func genesisDidFinishLoading() {
        
    }
    
    func genesisDidEndWithSuccess() {

    }
    
    func genesisDidEndWithFailure(errorCode: GenesisError) {
        
    }
    
    func genesisDidEndWithCancel() {

    }
    
    func genesisValidationError(error: GenesisValidationError) {
        
    }
}
