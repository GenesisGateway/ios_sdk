//
//  Currency.swift
//  GenesisSwift
//

import Foundation

public enum Currency: String {
    case USD
    case EUR
    case JPY
    case KWD
    case CNY
    case GBP
    case Unsupported
}

public struct CurrencyInfo {
    public let name: Currency
    public let exponent: Int
}

extension CurrencyInfo: Equatable {
    public static func == (lhs: CurrencyInfo, rhs: CurrencyInfo) -> Bool {
        return lhs.name == rhs.name
    }
}

public final class Currencies {
    public let USD = CurrencyInfo(name: .USD, exponent: 2)
    public let EUR = CurrencyInfo(name: .EUR, exponent: 2)
    public let JPY = CurrencyInfo(name: .JPY, exponent: 0)
    public let KWD = CurrencyInfo(name: .KWD, exponent: 3)
    public let CNY = CurrencyInfo(name: .CNY, exponent: 2)
    public let GBP = CurrencyInfo(name: .GBP, exponent: 2)
    
    public init() {}
    
    public var allCurrencies: Array<CurrencyInfo> {
        get {
            return [
                USD, EUR, JPY, KWD, CNY, GBP
            ]}
    }
    
    public class func convertToMinor(fromAmount amount: Decimal, andCurrency currency: Currency) -> String? {
        guard let currencyInfo = find(key: currency) else { return nil }
        let power: Decimal = pow(10, currencyInfo.exponent)
        let conversion = NSDecimalNumber(decimal: amount * power)
        let result = Int(truncating: conversion)
        
        return String(result)
    }
    
    public class func convertToDecimal(fromMinorString string: String, andCurrency currency: Currency) -> Decimal? {
        guard let currencyInfo = find(key: currency) else { return nil }
        guard let decimal = Decimal(string: string) else { return nil }
        let result = Decimal(sign: .plus, exponent: -currencyInfo.exponent, significand: decimal)
        
        return result
    }
    
    public class func find(key: String) -> Currency {
        let foundCurrencies = Currencies().allCurrencies.filter({ $0.name.rawValue == key })
        guard let currencyInfo = foundCurrencies.first else {
            return .Unsupported
        }
        return currencyInfo.name
    }
    
    public class func find(key: Currency) -> CurrencyInfo? {
        let foundCurrencies = Currencies().allCurrencies.filter({ $0.name == key })
        guard let currencyInfo = foundCurrencies.first else {
            return nil
        }
        return currencyInfo
    }
    
    public class func findCurrencyInfoByName(name: String) -> CurrencyInfo? {
        let currency = Currencies.find(key: name)
        
        guard currency != .Unsupported else {
            return nil
        }
  
        return Currencies.find(key: currency)
    }
}
