//
//  Recurring.swift
//  GenesisSwift
//
//  Created by Georgi Yanakiev emerchantpay on 12.01.23.
//  Copyright © 2023 eMerchantPay. All rights reserved.
//

import Foundation

public struct RecurringType {

    public enum TypeValues: String, CaseIterable {
        case initial
        case managed
        case subsequent
    }

    public let type: TypeValues

    public init(type: TypeValues) {
        self.type = type
    }
}

public struct RecurringCategory {

    public enum CategoryValues: String, CaseIterable {
        case subscription
        case standingOrder = "standing_order"
    }

    public let category: CategoryValues

    public init(category: CategoryValues = .subscription) {
        self.category = category
    }
}

// MARK: - GenesisDescriptionProtocol

extension RecurringType: GenesisDescriptionProtocol, XMLConvertable {

    func description() -> String {
        type.rawValue
    }
}

extension RecurringCategory: GenesisDescriptionProtocol, XMLConvertable {

    func description() -> String {
        category.rawValue
    }
}
