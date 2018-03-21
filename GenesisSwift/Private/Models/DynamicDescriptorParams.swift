//
//  DynamicDescriptorParams.swift
//  GenesisSwift
//

import Foundation

struct DynamicDescriptorParams {
    let merchantName: String?
    let merchantCity: String?
    
    var description: String {
        var xmlString = ""
        if (merchantName != nil) {
            xmlString += "<merchant_name>" + merchantName! + "</merchant_name name>"
        }
        if (merchantCity != nil) {
            xmlString += "<merchant_city>" + merchantCity! + "</merchant_city>"
        }
        return xmlString
    }
}
