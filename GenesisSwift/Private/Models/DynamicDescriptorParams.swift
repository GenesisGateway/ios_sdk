//
//  DynamicDescriptorParams.swift
//  GenesisSwift
//

import Foundation

public struct DynamicDescriptorParams {
    public let merchantName: String?
    public let merchantCity: String?
    public let subMerchantId: String?

    subscript(key: String) -> Any? {
        switch key {
        case PropertyKeys.MerchantNameKey: return merchantName
        case PropertyKeys.MerchantCityKey: return merchantCity
        case PropertyKeys.SubMerchantIdKey: return subMerchantId
        default: return nil
        }
    }
}

// MARK: - GenesisDescriptionProtocol
extension DynamicDescriptorParams: GenesisDescriptionProtocol {
    func description() -> String {
        toXmlString()
    }
}

// MARK: - GenesisXmlObjectProtocol
extension DynamicDescriptorParams: GenesisXmlObjectProtocol {
    func propertyMap() -> [String: String] {
        [PropertyKeys.MerchantNameKey: "mechant_name",
         PropertyKeys.MerchantCityKey: "merchant_city",
         PropertyKeys.SubMerchantIdKey: "sub_merchant_id"]
    }

    func toXmlString() -> String {
        var xmlString = ""
        for (key, value) in propertyMap() {
            guard let varValue = self[key] else { continue }
            xmlString += "<\(value)>" + String(describing: varValue) + "</\(value)>"
        }
        return xmlString
    }
}
