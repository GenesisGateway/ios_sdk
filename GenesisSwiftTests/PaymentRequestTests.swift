//
//  PaymentRequestTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import GenesisSwift

final class PaymentRequestTests: XCTestCase {

    private var sut: PaymentRequest!

    override func setUp() {
        super.setUp()
        sut = createPaymentRequest()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testProperties() {
        XCTAssertEqual(sut.amount, 1234.56)
        XCTAssertEqual(sut.transactionId, "fixed.transactionId")
        XCTAssertEqual(sut.currency, Currencies().USD)
        XCTAssertEqual(sut.customerEmail, "fixed.email")
        XCTAssertEqual(sut.customerPhone, "123456789")
        XCTAssertEqual(sut.billingAddress.address1, "fixed.address1")
        XCTAssertEqual(sut.transactionTypes.first?.name, TransactionName.authorize)
        XCTAssertEqual(sut.notificationUrl, "fixed.url")

        XCTAssertTrue(sut.payLater ?? false)
        XCTAssertTrue(sut.crypto ?? false)
        XCTAssertTrue(sut.gaming ?? false)
    }

    func testValidation() {
        var items = ["amount", "notificationUrl", "customerPhone", "consumerId", "transactionId", "customerEmail", "firstName", "lastName", "address1", "zipCode", "city", "country"]

        let paymentAddress = PaymentAddress(firstName: "", lastName: "", address1: "", address2: "", zipCode: "", city: "", state: "", country: IsoCountryCodes.search(byName: "fixed.country"))

        sut = PaymentRequest(transactionId: "", amount: 0, currency: Currencies().EUR, customerEmail: "", customerPhone: "", billingAddress: paymentAddress, transactionTypes: [PaymentTransactionType(name: .sale)], notificationUrl: "")
        sut.consumerId = "asdasdsadasasdasda"

        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.amount = -1
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.amount = 0
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.amount = 10
        items.removeFirst()
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.notificationUrl = "notificationUrl"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.notificationUrl = "http://notificationUrl.com"
        items.removeFirst()
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.customerPhone = "asdfgh123456"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.customerPhone = "123a456"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.customerPhone = "123456a"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.customerPhone = "12345678"
        items.removeFirst()
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.customerPhone = "+12345678"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.customerPhone = "0012345678"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.consumerId = "12345678900"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.consumerId = "1234567890"
        items.removeFirst()
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.consumerId = "1234"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.transactionId = "transactionId"
        items.removeFirst()
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.customerEmail = "mailmail"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.customerEmail = "mailmail.com"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.customerEmail = "mail@mail.c"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)

        sut.customerEmail = "mail@mail.com"
        items.removeFirst()
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)
    }

    func testInvalid3DSv2PaymentRequest() {

        // make sure that only one wrong parameter is detected
        sut.customerEmail = "customer@mail.com"
        sut.notificationUrl = "https://google.com"
        sut.billingAddress.state = "NY"
        sut.threeDSV2Params = nil

        sut.transactionTypes = [PaymentTransactionType(name: .authorize)]
        XCTAssertNoThrow(try sut.isValidData())
        sut.transactionTypes = [PaymentTransactionType(name: .authorize3d)]
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameter(ThreeDSV2ParamsKey, "").localizedDescription)
        sut.threeDSV2Params = ThreeDSV2Params()
        XCTAssertNoThrow(try sut.isValidData())
        sut.threeDSV2Params = nil

        sut.transactionTypes = [PaymentTransactionType(name: .sale)]
        XCTAssertNoThrow(try sut.isValidData())
        sut.transactionTypes = [PaymentTransactionType(name: .sale3d)]
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameter(ThreeDSV2ParamsKey, "").localizedDescription)
        sut.threeDSV2Params = ThreeDSV2Params()
        XCTAssertNoThrow(try sut.isValidData())
        sut.threeDSV2Params = nil

        sut.transactionTypes = [PaymentTransactionType(name: .initRecurringSale)]
        XCTAssertNoThrow(try sut.isValidData())
        sut.transactionTypes = [PaymentTransactionType(name: .initRecurringSale3d)]
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameter(ThreeDSV2ParamsKey, "").localizedDescription)
        sut.threeDSV2Params = ThreeDSV2Params()
        XCTAssertNoThrow(try sut.isValidData())
        sut.threeDSV2Params = nil
    }

    func test3DSv2() {

        let date = Date()
        let formattedDate = date.iso8601Date

        var threeDSV2Params = ThreeDSV2Params()

        threeDSV2Params.controlParams.challengeWindowSize = .fullScreen

        threeDSV2Params.purchaseParams = ThreeDSV2Params.PurchaseParams(category: .prepaidActivation)

        threeDSV2Params.recurringParams = ThreeDSV2Params.RecurringParams(expirationDate: date, frequency: 30)

        threeDSV2Params.merchantRiskParams = ThreeDSV2Params.MerchantRiskParams(shippingIndicator: .sameAsBilling,
                                                                                deliveryTimeframe: .overNight,
                                                                                reorderItemsIndicator: .firstTime,
                                                                                preOrderPurchaseIndicator: .futureAvailability,
                                                                                preOrderDate: date,
                                                                                giftCard: true,
                                                                                giftCardCount: 5)

        threeDSV2Params.cardHolderAccountParams =
            ThreeDSV2Params.CardHolderAccountParams(creationDate: date,
                                                    updateIndicator: .currentTransaction,
                                                    lastChangeDate: date,
                                                    passwordChangeIndicator: .between30To60Days,
                                                    passwordChangeDate: date,
                                                    shippingAddressUsageIndicator: .lessThan30Days,
                                                    shippingAddressDateFirstUsed: Date(),
                                                    transactionsActivityLast24Hours: 1,
                                                    transactionsActivityPreviousYear: 121,
                                                    provisionAttemptsLast24Hours: 3,
                                                    purchasesCountLast6Months: 57,
                                                    suspiciousActivityIndicator: .noSuspiciousObserved,
                                                    registrationIndicator: .guestCheckout,
                                                    registrationDate: date)

        sut.threeDSV2Params = threeDSV2Params

        // test the generated XML that is sent to Genesis

        let xml = sut.toXmlString()
        guard let threeDSXML = xmlValue(inTag: "threeds_v2_params", from: xml) else {
            XCTFail("No 'threeds_v2_params' tag found")
            return
        }

        guard let controlXML = xmlValue(inTag: "control", from: threeDSXML) else {
            XCTFail("No 'control' tag found")
            return
        }
        XCTAssertEqual("application", xmlValue(inTag: "device_type", from: controlXML))
        XCTAssertNotEqual("browser", xmlValue(inTag: "device_type", from: controlXML))
        XCTAssertEqual("full_screen", xmlValue(inTag: "challenge_window_size", from: controlXML))
        XCTAssertEqual("no_preference", xmlValue(inTag: "challenge_indicator", from: controlXML))

        guard let purchaseXML = xmlValue(inTag: "purchase", from: threeDSXML) else {
            XCTFail("No 'purchase' tag found")
            return
        }
        XCTAssertEqual("prepaid_activation", xmlValue(inTag: "category", from: purchaseXML))

        guard let recurringXML = xmlValue(inTag: "recurring", from: threeDSXML) else {
            XCTFail("No 'recurring' tag found")
            return
        }
        XCTAssertEqual(formattedDate, xmlValue(inTag: "expiration_date", from: recurringXML))
        XCTAssertEqual("30", xmlValue(inTag: "frequency", from: recurringXML))

        guard let merchantRiskXML = xmlValue(inTag: "merchant_risk", from: threeDSXML) else {
            XCTFail("No 'merchant_risk' tag found")
            return
        }
        XCTAssertEqual("same_as_billing", xmlValue(inTag: "shipping_indicator", from: merchantRiskXML))
        XCTAssertEqual("over_night", xmlValue(inTag: "delivery_timeframe", from: merchantRiskXML))
        XCTAssertEqual("first_time", xmlValue(inTag: "reorder_items_indicator", from: merchantRiskXML))
        XCTAssertEqual("future_availability", xmlValue(inTag: "pre_order_purchase_indicator", from: merchantRiskXML))
        XCTAssertEqual(formattedDate, xmlValue(inTag: "pre_order_date", from: merchantRiskXML))
        XCTAssertEqual("true", xmlValue(inTag: "gift_card", from: merchantRiskXML))
        XCTAssertEqual("5", xmlValue(inTag: "gift_card_count", from: merchantRiskXML))

        guard let cardHolderAccountXML = xmlValue(inTag: "card_holder_account", from: threeDSXML) else {
            XCTFail("No 'card_holder_account' tag found")
            return
        }
        XCTAssertEqual(formattedDate, xmlValue(inTag: "creation_date", from: cardHolderAccountXML))
        XCTAssertEqual("current_transaction", xmlValue(inTag: "update_indicator", from: cardHolderAccountXML))
        XCTAssertEqual(formattedDate, xmlValue(inTag: "last_change_date", from: cardHolderAccountXML))
        XCTAssertEqual("30_to_60_days", xmlValue(inTag: "password_change_indicator", from: cardHolderAccountXML))
        XCTAssertEqual(formattedDate, xmlValue(inTag: "password_change_date", from: cardHolderAccountXML))
        XCTAssertEqual("less_than_30days", xmlValue(inTag: "shipping_address_usage_indicator", from: cardHolderAccountXML))
        XCTAssertEqual(formattedDate, xmlValue(inTag: "shipping_address_date_first_used", from: cardHolderAccountXML))
        XCTAssertEqual("1", xmlValue(inTag: "transactions_activity_last_24_hours", from: cardHolderAccountXML))
        XCTAssertEqual("121", xmlValue(inTag: "transactions_activity_previous_year", from: cardHolderAccountXML))
        XCTAssertEqual("3", xmlValue(inTag: "provision_attempts_last_24_hours", from: cardHolderAccountXML))
        XCTAssertEqual("57", xmlValue(inTag: "purchases_count_last_6_months", from: cardHolderAccountXML))
        XCTAssertEqual("no_suspicious_observed", xmlValue(inTag: "suspicious_activity_indicator", from: cardHolderAccountXML))
        XCTAssertEqual("guest_checkout", xmlValue(inTag: "registration_indicator", from: cardHolderAccountXML))
        XCTAssertEqual(formattedDate, xmlValue(inTag: "registration_date", from: cardHolderAccountXML))
    }
}

private extension PaymentRequestTests {

    func createPaymentAddress() -> PaymentAddress {
        PaymentAddress(firstName: "fixed.firstName",
                       lastName: "fixed.lastName",
                       address1: "fixed.address1",
                       address2: "fixed.address2",
                       zipCode: "fixed.zipCode",
                       city: "fixed.city",
                       state: "fixed.state",
                       country: IsoCountryCodes.search(byName: "United States"))
    }

    func createPaymentRequest() -> PaymentRequest {

        let transactionTypes = [PaymentTransactionType(name: .authorize),
                                PaymentTransactionType(name: .sale)]
        let paymentRequest = PaymentRequest(transactionId: "fixed.transactionId",
                                            amount: 1234.56,
                                            currency: Currencies().USD,
                                            customerEmail: "fixed.email",
                                            customerPhone: "123456789",
                                            billingAddress: createPaymentAddress(),
                                            transactionTypes: transactionTypes,
                                            notificationUrl: "fixed.url")
        paymentRequest.payLater = true
        paymentRequest.crypto = true
        paymentRequest.gaming = true

        return paymentRequest
    }

    func validationWithExpectedError(errorDescription: String?) {
        guard let errorDescription = errorDescription else {
            XCTFail("Must provide error description")
            return
        }

        do {
            try sut.isValidData()
            XCTFail("The test should not pass: \(errorDescription)")
        } catch {
            XCTAssertEqual(error.localizedDescription, errorDescription)
        }
    }

    func xmlValue(inTag tag: String, from xml: String) -> String? {

        let startTag = "<\(tag)>"
        let endTag = "</\(tag)>"

        guard let startIndex = xml.range(of: startTag, options: .caseInsensitive)?.upperBound else { return nil }
        guard let endIndex = xml.range(of: endTag, options: .caseInsensitive)?.lowerBound else { return nil }
        guard startIndex < endIndex else { return nil }

        return String(xml[startIndex..<endIndex])
    }
}
