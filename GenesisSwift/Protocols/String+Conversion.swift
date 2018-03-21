//
//  String+Conversion.swift
//  GenesisSwift
//

import Foundation

extension String {
    public func explicitConvertionToDecimal() -> Decimal? {
        struct StaticFormatter {
            static let formatter: NumberFormatter = {
                let tmpFormatter = NumberFormatter()
                tmpFormatter.generatesDecimalNumbers = true
                tmpFormatter.numberStyle = NumberFormatter.Style.decimal
                return tmpFormatter
            }()
        }
        
        if let decimalNumber = StaticFormatter.formatter.number(from: self) as? Decimal  {
            return decimalNumber
        }
        
        return nil
    }
}
