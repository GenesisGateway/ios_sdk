//
//  PaymentAddressTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import GenesisSwift

class PaymentAddressTests: XCTestCase {
    
    var sut: PaymentAddress!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProperties() {
        sut = PaymentAddress(firstName: "fixed.firstName", lastName: "fixed.lastName", address1: "fixed.address1", address2: "fixed.address2", zipCode: "fixed.zipCode", city: "fixed.city", state: "fixed.state", country: IsoCountryCodes.search(byName: "fixed.country"))
        XCTAssertEqual(sut.firstName, "fixed.firstName")
        XCTAssertEqual(sut.lastName, "fixed.lastName")
        XCTAssertEqual(sut.address1, "fixed.address1")
        XCTAssertEqual(sut.address2, "fixed.address2")
        XCTAssertEqual(sut.zipCode, "fixed.zipCode")
        XCTAssertEqual(sut.city, "fixed.city")
        XCTAssertEqual(sut.state, "fixed.state")
        XCTAssertTrue(sut.country.alpha2.isEmpty)
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
       sut = PaymentAddress(firstName: "", lastName: "", address1: "", address2: "", zipCode: "", city: "", state: "", country: IsoCountryCodes.search(byName: "fixed.country"))
        
        validationWithExpectedError(errorDescription: GenesisValidationError.firstNameError.localizedDescription)
        
        sut.firstName = "firstName"
        validationWithExpectedError(errorDescription: GenesisValidationError.lastNameError.localizedDescription)
        
        sut.lastName = "lastName"
        validationWithExpectedError(errorDescription: GenesisValidationError.address1Error.localizedDescription)
        
        sut.address1 = "address1"
        validationWithExpectedError(errorDescription: GenesisValidationError.zipCodeError.localizedDescription)
        
        sut.zipCode = "zipCode"
        validationWithExpectedError(errorDescription: GenesisValidationError.cityError.localizedDescription)
        
        sut.city = "city"
        validationWithExpectedError(errorDescription: GenesisValidationError.countryISOCodeError.localizedDescription)
        
        sut.country = IsoCountryCodes.search(byName: "United States")
        validationWithExpectedError(errorDescription: nil)
    }
}

