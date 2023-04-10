//
//  PaymentSubtype.swift
//  GenesisSwift
//
//  Created by Georgi Yanakiev emerchantpay on 3.04.23.
//  Copyright © 2023 eMerchantPay. All rights reserved.
//

public struct PaymentSubtype {

    public enum TypeValues: String, CaseIterable {
        case authorize
        case sale
        case initRecurringSale = "init_recurring_sale"
    }

    public let type: TypeValues

    public init(type: TypeValues) {
        self.type = type
    }
}

// MARK: - GenesisDescriptionProtocol

extension PaymentSubtype: GenesisDescriptionProtocol, XMLConvertable {

    func description() -> String {
        type.rawValue
    }
}
