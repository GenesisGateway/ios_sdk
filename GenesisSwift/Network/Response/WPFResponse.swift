//
//  WPFResponse.swift
//  GenesisSwift
//

import Foundation

final class WPFResponse: Response {
    private(set) var transactionId = ""
    private(set) var timestamp: Date?
    private(set) var amount: Double = 0
    private(set) var currency = ""
    private(set) var redirectUrl = ""

    override func parser(foundCharacters string: String, forElementName elementName: String) {
        super.parser(foundCharacters: string, forElementName: elementName)

        switch elementName {
        case "transaction_id":
            transactionId = string
        case "timestamp":
            timestamp = string.dateFromISO8601
        case "amount":
            amount = Double(string) ?? 0
        case "currency":
            currency = string
        case "redirect_url":
            redirectUrl = string
        default:
            break
        }
    }
}
