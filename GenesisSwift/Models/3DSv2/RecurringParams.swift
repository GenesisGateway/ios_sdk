//
//  RecurringParams.swift
//  GenesisSwift
//
//  Created by Ivaylo Hadzhiev on 14.10.22.
//  Copyright © 2022 eMerchantPay. All rights reserved.
//

import Foundation

public extension ThreeDSV2Params {

    struct RecurringParams {

        public var expirationDate: Date?
        public var frequency: Int?

        public init(expirationDate: Date? = nil, frequency: Int? = nil) {
            self.expirationDate = expirationDate
            self.frequency = frequency
        }
    }
}

// MARK: - GenesisDescriptionProtocol

extension ThreeDSV2Params.RecurringParams: GenesisDescriptionProtocol, XMLConvertable {

    func description() -> String {
        var xmlString = ""
        xmlString += toXML(name: "expiration_date", value: expirationDate?.iso8601Date)
        if let frequency = frequency {
            xmlString += toXML(name: "frequency", value: String(describing: frequency))
        }
        return xmlString
    }
}
