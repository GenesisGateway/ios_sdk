//
//  GenesisTest.swift
//  GenesisSwiftTests
//

import XCTest
@testable import GenesisSwift

final class GenesisTest: XCTestCase {

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

        paymentRequest.transactionTypes.first?.recurringType = RecurringType(type: .managed)

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
}

// MARK: - GenesisDelegate
extension GenesisTest: GenesisDelegate {

    func genesisDidFinishLoading(userInfo: [AnyHashable: Any]) {
        print("Loading transaction: \(userInfo[GenesisInfoKeys.uniqueId]!)")
    }

    func genesisDidEndWithSuccess(userInfo: [AnyHashable: Any]) {
        print("""
        Transaction succeeded
        uniqueId: \(userInfo[GenesisInfoKeys.uniqueId]!),
        status: \(userInfo[GenesisInfoKeys.status]!),
        transactionId: \(userInfo[GenesisInfoKeys.transactionId]!),
        timestamp: \((userInfo[GenesisInfoKeys.timestamp] as? Date)!),
        amount: \((userInfo[GenesisInfoKeys.timestamp] as? Double)!),
        currency: \(userInfo[GenesisInfoKeys.currency]!)
        """)
    }

    func genesisDidEndWithCancel(userInfo: [AnyHashable: Any]) {
        print("Transaction cancelled: \(userInfo[GenesisInfoKeys.uniqueId]!)")
    }

    func genesisDidEndWithFailure(userInfo: [AnyHashable: Any], errorCode: GenesisError) {
        print("Transaction failed: \(userInfo[GenesisInfoKeys.uniqueId] ?? "N/A")")
    }

    func genesisValidationError(error: GenesisValidationError) {
        print("Error: \(error.errorUserInfo)")
    }
}
