//
//  WPFResponse.swift
//  GenesisSwift
//

import Foundation

class WPFResponse: Response {
    var transactionId: String = String()
    var timestamp: Date?
    var amount: Double = Double()
    var currency: String = String()
    var redirectUrl: String = String()
    
    override func parser(foundCharacters string: String, forElementName elementName: String) {
        super.parser(foundCharacters: string, forElementName: elementName)
        
        switch elementName {
        case "transaction_id":
            self.transactionId = string
        case "timestamp":
            self.timestamp = string.dateFromISO8601
        case "amount":
            self.amount = Double(string)!
        case "currency":
            self.currency = string
        case "redirect_url":
            self.redirectUrl = string
        default:
            break
        }
    }
}
