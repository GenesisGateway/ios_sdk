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
                address1: String,
                address2: String?,
                zipCode: String,
                city: String,
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
            case "firstName": return firstName
            case "lastName": return lastName
            case "address1": return address1
            case "address2": return address2
            case "zipCode": return zipCode
            case "city": return city
            case "state": return state
            case "country": return country.alpha2
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
        guard !firstName.isEmpty else {
            throw GenesisValidationError.firstNameError
        }
        
        guard !lastName.isEmpty else {
            throw GenesisValidationError.lastNameError
        }
        
        guard !address1.isEmpty else {
            throw GenesisValidationError.address1Error
        }
        
        guard !zipCode.isEmpty else {
            throw GenesisValidationError.zipCodeError
        }
        
        guard !city.isEmpty else {
            throw GenesisValidationError.cityError
        }
        
        guard !country.alpha2.isEmpty else {
            throw GenesisValidationError.countryISOCodeError
        }
    }
}


// MARK: GenesisXmlObjectProtocol
extension PaymentAddress: GenesisXmlObjectProtocol {
    func propertyMap() -> ([String : String]) {
        return [
            "firstName": "first_name",
            "lastName": "last_name",
            "address1": "address1",
            "address2": "address2",
            "zipCode": "zip_code",
            "city": "city",
            "state": "state",
            "country": "country"]
    }
    
    func toXmlString() -> String {
        var xmlString = ""
        for (key, value) in self.propertyMap() {
            guard let varValue = self[key] else { continue }
            xmlString += "<\(value)>" + String(describing:varValue) + "</\(value)>"
        }
        return xmlString
    }
}
