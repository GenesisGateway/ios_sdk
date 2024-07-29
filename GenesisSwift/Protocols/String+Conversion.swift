//
//  String+Conversion.swift
//  GenesisSwift
//

import Foundation

public extension String {

    func explicitConvertionToDecimal() -> Decimal? {
        enum StaticFormatter {
            static let decimalFormatter: NumberFormatter = {
                let formatter = NumberFormatter()
                formatter.generatesDecimalNumbers = true
                formatter.numberStyle = .decimal
                return formatter
            }()
        }

        return StaticFormatter.decimalFormatter.number(from: self) as? Decimal
    }
}
