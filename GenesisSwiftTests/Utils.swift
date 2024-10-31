//
//  Utils.swift
//  GenesisSwiftTests
//
//  Created by Ivaylo Hadzhiev on 23.10.24.
//  Copyright © 2024 eMerchantPay. All rights reserved.
//

import Foundation

enum Utils {

    static func valueBetween(start: String, end: String, in text: String) -> String? {
        guard let startIndex = text.range(of: start, options: .caseInsensitive)?.upperBound else { return nil }
        guard let endIndex = text.range(of: end, options: .caseInsensitive)?.lowerBound else { return nil }
        guard startIndex < endIndex else { return nil }

        return String(text[startIndex..<endIndex])
    }

    static func xmlValue(inTag tag: String, from xml: String) -> String? {
        let startTag = "<\(tag)>"
        let endTag = "</\(tag)>"
        return valueBetween(start: startTag, end: endTag, in: xml)
    }
}
