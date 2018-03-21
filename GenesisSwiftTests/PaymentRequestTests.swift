//
//  PaymentRequestTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import GenesisSwift

class PaymentRequestTests: XCTestCase {
    
    var sut: PaymentRequest!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProperties() {
        let billingAddress = PaymentAddress(firstName: "fixed.firstName", lastName: "fixed.lastName", address1: "fixed.address1", address2: "fixed.address2", zipCode: "fixed.zipCode", city: "fixed.city", state: "fixed.state", country: IsoCountryCodes.search(byName: "United States"))
        sut = PaymentRequest(transactionId: "fixed.transactionId", amount: 1234.56, currency: Currencies().USD, customerEmail: "fixed.email", customerPhone: "123456789", billingAddress: billingAddress, transactionTypes: [.authorize, .sale], notificationUrl: "fixed.url")
        
        XCTAssertEqual(sut.amount, 1234.56)
        XCTAssertEqual(sut.transactionId, "fixed.transactionId")
        XCTAssertEqual(sut.currency, Currencies().USD)
        XCTAssertEqual(sut.customerEmail, "fixed.email")
        XCTAssertEqual(sut.customerPhone, "123456789")
        XCTAssertEqual(sut.billingAddress.address1, billingAddress.address1)
        XCTAssertEqual(sut.transactionTypes.first?.name, TransactionName.authorize)
        XCTAssertEqual(sut.notificationUrl, "fixed.url")
    }
    
    func validationWithExpectedError(errorDescription: String?) {
        do {
            try sut.isValidData()
        } catch {
            XCTAssertEqual(error.localizedDescription, errorDescription)
            return
        }
        
        XCTAssertNil(errorDescription)
    }
    
    func testValidation() {
        let paymentAddress = PaymentAddress(firstName: "", lastName: "", address1: "", address2: "", zipCode: "", city: "", state: "", country: IsoCountryCodes.search(byName: "fixed.country"))
        
        sut = PaymentRequest(transactionId: "", amount: 0, currency: Currencies().EUR, customerEmail: "", customerPhone: "", billingAddress: paymentAddress, transactionTypes: [], notificationUrl: "")
        
        validationWithExpectedError(errorDescription: GenesisValidationError.customerPhoneError.localizedDescription)
        
        sut.customerPhone = "asdfgh123456"
        validationWithExpectedError(errorDescription: GenesisValidationError.customerPhoneError.localizedDescription)
        
        sut.customerPhone = "123a456"
        validationWithExpectedError(errorDescription: GenesisValidationError.customerPhoneError.localizedDescription)
        
        sut.customerPhone = "123456a"
        validationWithExpectedError(errorDescription: GenesisValidationError.customerPhoneError.localizedDescription)
        
        sut.customerPhone = "12345678"
        validationWithExpectedError(errorDescription: GenesisValidationError.customerEmailError.localizedDescription)
        
        sut.customerPhone = "+12345678"
        validationWithExpectedError(errorDescription: GenesisValidationError.customerEmailError.localizedDescription)
        
        sut.customerPhone = "0012345678"
        validationWithExpectedError(errorDescription: GenesisValidationError.customerEmailError.localizedDescription)
        
        sut.customerEmail = "mailmail"
        validationWithExpectedError(errorDescription: GenesisValidationError.customerEmailError.localizedDescription)

        sut.customerEmail = "mailmail.com"
        validationWithExpectedError(errorDescription: GenesisValidationError.customerEmailError.localizedDescription)
        
        sut.customerEmail = "mail@mail.c"
        validationWithExpectedError(errorDescription: GenesisValidationError.customerEmailError.localizedDescription)
        
        sut.customerEmail = "mail@mail.com"
        validationWithExpectedError(errorDescription: GenesisValidationError.amountError.localizedDescription)
        
        sut.amount = -1
        validationWithExpectedError(errorDescription: GenesisValidationError.amountError.localizedDescription)
        
        sut.amount = 0
        validationWithExpectedError(errorDescription: GenesisValidationError.amountError.localizedDescription)
        
        sut.amount = 10
        validationWithExpectedError(errorDescription: GenesisValidationError.transactionIdError.localizedDescription)

        sut.transactionId = "transactionId"
        validationWithExpectedError(errorDescription: GenesisValidationError.transactionTypesError.localizedDescription)
        
        sut.transactionTypes = [PaymentTransactionType(name: .sale)]
        validationWithExpectedError(errorDescription: GenesisValidationError.notificationUrlError.localizedDescription)
        
        sut.notificationUrl = "notificationUrl"
        validationWithExpectedError(errorDescription: GenesisValidationError.notificationUrlError.localizedDescription)
        
        sut.notificationUrl = "http://notificationUrl.com"
        //from address error
        validationWithExpectedError(errorDescription: GenesisValidationError.firstNameError.localizedDescription)
    }
}
