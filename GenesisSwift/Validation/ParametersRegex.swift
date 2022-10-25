//
//  ParametersRegex.swift
//  GenesisSwift
//

import Foundation

class ParametersRegex {
    static func regexForKey(key: String) -> String {
        switch key {
        case ConsumerId:
            return "^\\d{1,10}$"
        case TransactionIdKey,
             UsageKey,
             FirstNameKey,
             LastNameKey,
             Address1Key,
             Address2Key,
             CityKey:
            return "^.{1,255}$"
        case CountryKey,
             StateKey:
            return "^.{1,2}$"
        case CustomerAccountIdKey:
            return "^.{1,13}$"
        case CustomerEmailKey:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case CustomerPhoneKey:
            return "^[0-9\\+]{1,}[0-9\\-]{3,15}$"
        default:
            return ""
        }
    }
}
