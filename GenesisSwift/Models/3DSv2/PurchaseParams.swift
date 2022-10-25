//
//  PurchaseParams.swift
//  GenesisSwift
//
//  Created by Ivaylo Hadzhiev on 14.10.22.
//  Copyright © 2022 eMerchantPay. All rights reserved.
//

import Foundation

public extension ThreeDSV2Params {

    struct PurchaseParams {

        public enum CategoryValues: String, CaseIterable {
            case goods
            case service
            case checkAcceptance = "check_acceptance"
            case accountFunding = "account_funding"
            case quasiCash = "quasi_cash"
            case prepaidActivation = "prepaid_activation"
            case loan
        }

        public var category: CategoryValues?

        public init(category: CategoryValues? = nil) {
            self.category = category
        }
    }
}

// MARK: - GenesisDescriptionProtocol

extension ThreeDSV2Params.PurchaseParams: GenesisDescriptionProtocol, XMLConvertable {

    func description() -> String {
        var xmlString = ""
        xmlString += toXML(name: "category", value: category?.rawValue)
        return xmlString
    }
}
