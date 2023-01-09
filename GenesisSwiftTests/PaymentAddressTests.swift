//
//  PaymentAddressTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import GenesisSwift

final class PaymentAddressTests: XCTestCase {
    private var sut: PaymentAddress!
}

// MARK: - Tests

extension PaymentAddressTests {

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
    
    func testValidation() {
        var items = ["firstName", "lastName", "country"]
        
       sut = PaymentAddress(firstName: "", lastName: "", address1: "", address2: "", zipCode: "", city: "", state: "",
                            country: IsoCountryCodes.search(byName: "fixed.country"))
        
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)
        
        sut.firstName = "firstName"
        items.removeFirst()
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameters(items, [""]).localizedDescription)
        
        sut.lastName = "lastName"
        items.removeFirst()
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameter(items.first!, "").localizedDescription)
        
        sut.address1 = "address1"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameter(items.first!, "").localizedDescription)
        
        sut.zipCode = "zipCode"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameter(items.first!, "").localizedDescription)
        
        sut.city = "city"
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameter(items.first!, "").localizedDescription)
        
        sut.country = IsoCountryCodes.search(byName: "United States")
        items = ["state"]
        validationWithExpectedError(errorDescription: GenesisValidationError.wrongValueForParameter(items.first!, "").localizedDescription)
        
        sut.state = "TX"
        validationWithExpectedError(errorDescription: nil)
    }
}

private extension PaymentAddressTests {

    func validationWithExpectedError(errorDescription: String?) {
        do {
            try sut.isValidData()
        } catch {
            XCTAssertEqual(error.localizedDescription, errorDescription)
            return
        }

        XCTAssertNil(errorDescription)
    }
}
