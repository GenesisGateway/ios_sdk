//
//  PaymentAddress.swift
//  GenesisSwift
//

import UIKit

public class PaymentAddress {

    public var firstName: String
    public var lastName: String
    public var address1: String
    public var address2: String?
    public var zipCode: String
    public var city: String
    public var state: String?
    public var country: IsoCountryInfo

/// Default initialization
///
/// - Parameters:
///     - firstName: Customer first name
///     - lastName: Customer last name
///     - address1: Primary address
///     - address2: Secondary address
///     - zipCode: ZIP code
///     - city: City
///     - state: State code in ISO 3166-2, required for USA and Canada
///     - country: Country code in ISO 3166
///
    public init(firstName: String,
                lastName: String,
                address1: String = "",
                address2: String? = nil,
                zipCode: String = "",
                city: String = "",
                state: String?,
                country: IsoCountryInfo) {
        self.firstName = firstName
        self.lastName = lastName
        self.address1 = address1
        self.address2 = address2
        self.zipCode = zipCode
        self.city = city
        self.state = state
        self.country = country
    }

    subscript(key: String) -> Any? {
        switch key {
        case PropertyKeys.FirstNameKey: return firstName
        case PropertyKeys.LastNameKey: return lastName
        case PropertyKeys.Address1Key: return address1
        case PropertyKeys.Address2Key: return address2
        case PropertyKeys.ZipCodeKey: return zipCode
        case PropertyKeys.CityKey: return city
        case PropertyKeys.StateKey: return state
        case PropertyKeys.CountryKey: return country.alpha2
        default: return nil
        }
    }
}

// MARK: - GenesisDescriptionProtocol
extension PaymentAddress: GenesisDescriptionProtocol {
    func description() -> String {
        toXmlString()
    }
}

// MARK: - ValidateInputDataProtocol
extension PaymentAddress: ValidateInputDataProtocol {
    public func isValidData() throws {
        let requiredParameters = RequiredParameters.requiredParametersForAddress()
        let validator = RequiredParametersValidator(withRequiredParameters: requiredParameters)

        try validator.isValidAddress(address: self)
    }
}

// MARK: - GenesisXmlObjectProtocol
extension PaymentAddress: GenesisXmlObjectProtocol {
    func propertyMap() -> [String: String] {
        [PropertyKeys.FirstNameKey: "first_name",
         PropertyKeys.LastNameKey: "last_name",
         PropertyKeys.Address1Key: "address1",
         PropertyKeys.Address2Key: "address2",
         PropertyKeys.ZipCodeKey: "zip_code",
         PropertyKeys.CityKey: "city",
         PropertyKeys.StateKey: "state",
         PropertyKeys.CountryKey: "country"]
    }

    func toXmlString() -> String {
        var xmlString = ""
        for (key, value) in propertyMap() {
            guard let varValue = self[key] else { continue }
            xmlString += "<\(value)>" + String(describing: varValue) + "</\(value)>"
        }
        return xmlString
    }
}
