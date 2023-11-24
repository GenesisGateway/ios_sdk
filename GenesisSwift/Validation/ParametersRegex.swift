//
//  ParametersRegex.swift
//  GenesisSwift
//

import Foundation

enum ParametersRegex {

    static func regexForKey(_ key: String) -> String {
        switch key {
        case PropertyKeys.ConsumerId:
            return "^\\d{1,10}$"
        case PropertyKeys.TransactionIdKey,
            PropertyKeys.UsageKey,
            PropertyKeys.FirstNameKey,
            PropertyKeys.LastNameKey,
            PropertyKeys.Address1Key,
            PropertyKeys.Address2Key,
            PropertyKeys.CityKey:
            return "^.{1,255}$"
        case PropertyKeys.CountryKey,
            PropertyKeys.StateKey:
            return "^.{1,2}$"
        case PropertyKeys.CustomerAccountIdKey:
            return "^.{1,13}$"
        case PropertyKeys.CustomerEmailKey:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case PropertyKeys.CustomerPhoneKey:
            return "^[0-9\\+][0-9\\-]{3,31}$"
        default:
            return ""
        }
    }
}
