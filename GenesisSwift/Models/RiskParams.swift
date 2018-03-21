//
//  RiskParams.swift
//  GenesisSwift
//

import Foundation

public final class RiskParams {
    
    public var userId: String?
    public var sessionId: String?
    public var ssn: String?
    public var macAddress: String?
    public var userLevel: String?
    public var email: String?
    public var phone: String?
    public var remoteIp: String?
    public var serialNumber: String?
    public var panTail: String?
    public var bin: String?
    public var firstName: String?
    public var lastName: String?
    public var country: IsoCountryInfo?
    public var pan: String?
    public var forwardedIp: String?
    public var username: String?
    public var password: String?
    public var binName: String?
    public var binPhone: String?
    
    public init() {
        
    }
    
/// Default initialization
///
/// - Parameters:
///     - userId: The customers user id
///     - sessionId: The customers session id
///     - ssn: Social Security number or equivalent value for non US customers
///     - macAddress: The customers mac address
///     - userLevel: A value describing the customers trust level, may be used by the risk management for configurable differentiated limits
///     - email: The customers email
///     - phone: The customers phone
///     - remoteIp: The customers ip address
///     - serialNumber: Custom serial number
///     - panTail: The last 4 digits of the card number
///     - bin: The first 6 digits of the card number
///     - firstName: Customer first name
///     - lastName: Customer last name
///     - country: The country of the customer
///     - pan: The PAN hash of the customer card number
///     - forwardedIp: MaxMind specific risk param
///     - username: MaxMind specific risk param
///     - password: MaxMind specific risk param
///     - binName: MaxMind specific risk param
///     - binPhone: MaxMind specific risk param
    
    public init(userId: String?,
         sessionId: String?,
         ssn: String?,
         macAddress: String?,
         userLevel: String?,
         email: String?,
         phone: String?,
         remoteIp: String?,
         serialNumber: String?,
         panTail: String?,
         bin: String?,
         firstName: String?,
         lastName: String?,
         country: IsoCountryInfo?,
         pan: String?,
         forwardedIp: String?,
         username: String?,
         password: String?,
         binName: String?,
         binPhone: String?) {
        
        self.userId = userId
        self.sessionId = sessionId
        self.ssn = ssn
        self.macAddress = macAddress
        self.userLevel = userLevel
        self.email = email
        self.phone = phone
        self.remoteIp = remoteIp
        self.serialNumber = serialNumber
        self.panTail = panTail
        self.bin = bin
        self.firstName = firstName
        self.lastName = lastName
        self.country = country
        self.pan = panTail
        self.forwardedIp = forwardedIp
        self.username = username
        self.password = password
        self.binName = binName
        self.binPhone = binPhone
    }
}

//MARK: GenesisDescriptionProtocol
extension RiskParams: GenesisDescriptionProtocol {
    func description() -> String {
        var xmlString = ""
        
        xmlString += toXML(name: "user_id", value: userId)
        xmlString += toXML(name: "session_id", value: sessionId)
        xmlString += toXML(name: "ssn", value: ssn)
        xmlString += toXML(name: "mac_address", value: macAddress)
        xmlString += toXML(name: "user_level", value: userLevel)
        xmlString += toXML(name: "email", value: email)
        xmlString += toXML(name: "phone", value: phone)
        xmlString += toXML(name: "remote_ip", value: remoteIp)
        xmlString += toXML(name: "serial_number", value: serialNumber)
        xmlString += toXML(name: "pan_tail", value: panTail)
        xmlString += toXML(name: "bin", value: bin)
        xmlString += toXML(name: "first_name", value: firstName)
        xmlString += toXML(name: "last_name", value: lastName)
        xmlString += toXML(name: "country", value: country?.name)
        xmlString += toXML(name: "pan", value: pan)
        xmlString += toXML(name: "forwarded_ip", value: forwardedIp)
        xmlString += toXML(name: "username", value: username)
        xmlString += toXML(name: "password", value: password)
        xmlString += toXML(name: "bin_name", value: binName)
        xmlString += toXML(name: "bin_phone", value: binPhone)
        
        return xmlString
    }
    
    
    func toXML(name: String, value: String?) -> String {
        guard let val = value else {
            return ""
        }
        let xml = "<\(name)>" + val + "</\(name)>"
        return xml
    }
}
