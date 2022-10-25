//
//  ThreeDSV2Params.swift
//  GenesisSwift
//
//  Created by Ivaylo Hadzhiev on 14.10.22.
//  Copyright © 2022 eMerchantPay. All rights reserved.
//

import Foundation

public struct ThreeDSV2Params {

    public var controlParams = ControlParams()
    public var purchaseParams: PurchaseParams?
    public var recurringParams: RecurringParams?
    public var merchantRiskParams: MerchantRiskParams?
    public var cardHolderAccountParams: CardHolderAccountParams?

    public init(purchaseParams: PurchaseParams? = nil,
                recurringParams: RecurringParams? = nil,
                merchantRiskParams: MerchantRiskParams? = nil,
                cardHolderAccountParams: CardHolderAccountParams? = nil) {
        self.purchaseParams = purchaseParams
        self.recurringParams = recurringParams
        self.merchantRiskParams = merchantRiskParams
        self.cardHolderAccountParams = cardHolderAccountParams
    }
}

private extension ThreeDSV2Params {

    subscript(key: String) -> Any? {
        switch key {
        case PropertyKeys.Control: return controlParams
        case PropertyKeys.Purchase: return purchaseParams
        case PropertyKeys.Recurring: return recurringParams
        case PropertyKeys.MerchantRisk: return merchantRiskParams
        case PropertyKeys.CardHolderAccount: return cardHolderAccountParams
        default: return nil
        }
    }
}

// MARK: - GenesisDescriptionProtocol

extension ThreeDSV2Params: GenesisDescriptionProtocol {
    func description() -> String {
        toXmlString()
    }
}

// MARK: - ValidateInputDataProtocol

extension ThreeDSV2Params: ValidateInputDataProtocol {

    public func isValidData() throws {
        // empty
    }
}

// MARK: - XML Generation

extension ThreeDSV2Params {

    func propertyMap() -> [String] {
        [PropertyKeys.Control,
         PropertyKeys.Purchase,
         PropertyKeys.Recurring,
         PropertyKeys.MerchantRisk,
         PropertyKeys.CardHolderAccount]
    }

    func toXmlString() -> String {
        var xmlString = ""

        for value in propertyMap() {
            guard let varValue = self[value] else { continue }

            var describing: String?
            if let structure = varValue as? GenesisDescriptionProtocol {
                describing = structure.description()
            }

            if let describing = describing, !describing.isEmpty {
                xmlString += "<\(value)>" + describing + "</\(value)>"
            }
        }

        return xmlString
    }
}
