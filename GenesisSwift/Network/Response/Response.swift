//
//  Response.swift
//  GenesisSwift
//

import Foundation

enum Status: String {
    case approved                       // Transaction was approved by the schemes and is successful.
    case declined                       // Transaction was declined by the schemes or risk management.
    case pendingAsync = "pending async" // An asynchronous transaction (3-D secure payment) has been initiated and is waiting for user input. Updates of this state will be sent to the notifi- cation url specified in request.
    case pending                        // The outcome of the transaction could not be determined, e.g. at a timeout situation. Transaction state will eventually change, so make a reconcile after a certain time frame.
    case error                          // An error has occurred while negotiating with the schemes.
    case refunded                       // Once an approved transaction is refunded the state changes to refunded.
    case chargebacked                   // Once an approved transaction is chargeback the state changes to change- backed. Chargeback is the state of rejecting an accepted transaction (with funds transferred) by the cardholder or the issuer
    case voided                         // Transaction was authorized, but later the merchant canceled it.
    case chargebackReversed = "chargeback reversed" // Once a chargebacked transaction is charged, the state changes to charge- back reversed. Chargeback has been canceled.
    case secondChargebacked = "second chargebacked" // Once a chargeback reversed transaction is chargebacked the state changes to second chargebacked.
    case pendingReview = "pending review" // Transaction on hold, a manual review will be done
    case new                              // Transaction is new.
    case unknown                          // Default unknown
}

class Response: NSObject, GenesisXmlParserDelegate {
    var status: Status = .unknown
    var uniqueId: String = String()

    var errorCode: GenesisError?
    var code: String?
    var technicalMessage: String?
    var message: String?
    
    var parser: GenesisXmlParser?
    
    public init(xmlString: String) {
        parser = GenesisXmlParser(data: xmlString.data(using: String.Encoding.utf8)!, searchedElement: "wpf_payment")
        super.init()
        parser?.delegate = self
        parser?.parse()
    }
    
    func parser(foundCharacters string: String, forElementName elementName: String) {
        switch elementName {
        case "status":
            self.status = Status(rawValue: string)!
        case "unique_id":
            self.uniqueId = string
        case "code":
            self.code = string
        case "technical_message":
            self.technicalMessage = string
        case "message":
            self.message = string
        default:
            break
        }
    }
    
    func didEndParsing() {
        errorCode = GenesisError(code: code, technicalMessage: technicalMessage, message: message)
    }
}
