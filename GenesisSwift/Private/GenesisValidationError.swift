//
//  GenesisValidationError.swift
//  GenesisSwift
//

import Foundation

enum GenesisValidationError: Error {
    case firstNameError
    case lastNameError
    case address1Error
    case zipCodeError
    case cityError
    case countryISOCodeError
    case customerPhoneError
    case customerEmailError
    case amountError
    case transactionIdError
    case transactionTypesError
    case notificationUrlError
}

extension GenesisValidationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .firstNameError: return "First name is required"
        case .lastNameError: return "Last name is required"
        case .address1Error: return "Address1 name is required"
        case .zipCodeError: return "ZipCode is required"
        case .cityError: return "City is required"
        case .countryISOCodeError: return "Country ISO code is required"
        case .customerPhoneError: return "Customer phone is not valid"
        case .customerEmailError: return "Customer email is not valid"
        case .amountError: return "Amount is required"
        case .transactionIdError: return "TransactionId is required"
        case .transactionTypesError: return "TransactionTypes are required"
        case .notificationUrlError: return "NotificationUrl is not valid"
        }
    }
}

extension GenesisValidationError: CustomNSError {
    static var errorDomain : String { return "GenesisSwift" }
    var errorUserInfo: [String: Any] { return ["error": errorDescription ?? ""] }
}
