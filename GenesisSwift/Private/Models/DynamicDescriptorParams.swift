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
        case MerchantNameKey: return merchantName
        case MerchantCityKey: return merchantCity
        case SubMerchantIdKey: return subMerchantId
        default: return nil
        }
    }
}

//MARK: GenesisDescriptionProtocol
extension DynamicDescriptorParams: GenesisDescriptionProtocol {
    func description() -> String {
        toXmlString()
    }

}

// MARK: GenesisXmlObjectProtocol
extension DynamicDescriptorParams: GenesisXmlObjectProtocol {
    func propertyMap() -> [String : String] {
        [MerchantNameKey: "mechant_name",
         MerchantCityKey: "merchant_city",
        SubMerchantIdKey: "sub_merchant_id"]
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

