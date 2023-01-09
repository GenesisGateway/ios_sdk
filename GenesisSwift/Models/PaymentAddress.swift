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
        get {
            switch key {
            case FirstNameKey: return firstName
            case LastNameKey: return lastName
            case Address1Key: return address1
            case Address2Key: return address2
            case ZipCodeKey: return zipCode
            case CityKey: return city
            case StateKey: return state
            case CountryKey: return country.alpha2
            default: return nil
            }
        }
    }
}

//MARK: GenesisDescriptionProtocol
extension PaymentAddress: GenesisDescriptionProtocol {
    func description() -> String {
        return self.toXmlString()
    }
    
}

//MARK: ValidateInputDataProtocol
extension PaymentAddress: ValidateInputDataProtocol {
    public func isValidData() throws {
        let requiredParameters = RequiredParameters.requiredParametersForAddress()
        let validator = RequiredParametersValidator(withRequiredParameters: requiredParameters)
        
        do {
            try validator.isValidAddress(address: self)
        } catch {
            throw error
        }
    }
}


// MARK: GenesisXmlObjectProtocol
extension PaymentAddress: GenesisXmlObjectProtocol {
    func propertyMap() -> ([String : String]) {
        return [
            FirstNameKey: "first_name",
            LastNameKey: "last_name",
            Address1Key: "address1",
            Address2Key: "address2",
            ZipCodeKey: "zip_code",
            CityKey: "city",
            StateKey: "state",
            CountryKey: "country"]
    }
    
    func toXmlString() -> String {
        var xmlString = ""
        for (key, value) in self.propertyMap() {
            guard let varValue = self[key] else { continue }
            xmlString += "<\(value)>" + String(describing: varValue) + "</\(value)>"
        }
        return xmlString
    }
}
