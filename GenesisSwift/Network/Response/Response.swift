//
//  Response.swift
//  GenesisSwift
//

import Foundation

enum Status: String {
    // Transaction was approved by the schemes and is successful.
    case approved

    // Transaction was declined by the schemes or risk management.
    case declined

    // An asynchronous transaction (3-D secure payment) has been initiated and is waiting for user input.
    // Updates of this state will be sent to the notifi- cation url specified in request.
    case pendingAsync = "pending_async"

    // The outcome of the transaction could not be determined, e.g. at a timeout situation.
    // Transaction state will eventually change, so make a reconcile after a certain time frame.
    case pending

    // An error has occurred while negotiating with the schemes.
    case error

    // Once an approved transaction is refunded the state changes to refunded.
    case refunded

    // Once an approved transaction is chargeback the state changes to change- backed.
    // Chargeback is the state of rejecting an accepted transaction (with funds transferred) by the cardholder or the issuer
    case chargebacked

    // Transaction was authorized, but later the merchant canceled it.
    case voided

    // Once a chargebacked transaction is charged, the state changes to charge- back reversed. Chargeback has been canceled.
    case chargebackReversed = "chargeback_reversed"

    // Once a chargeback reversed transaction is chargebacked the state changes to second chargebacked.
    case secondChargebacked = "second_chargebacked"

    // Transaction on hold, a manual review will be done
    case pendingReview = "pending_review"

    // Transaction is new.
    case new

    // Default unknown
    case unknown
}

class Response: NSObject, GenesisXmlParserDelegate {
    private(set) var status: Status = .unknown
    private(set) var uniqueId = ""

    private(set) var errorCode: GenesisError?
    private(set) var code: String?
    private(set) var technicalMessage: String?
    private(set) var message: String?

    private let parser: GenesisXmlParser

    init(xmlString: String) {
        parser = GenesisXmlParser(data: Data(xmlString.utf8), searchedElement: "wpf_payment")
        super.init()
        parser.delegate = self
        parser.parse()
    }

    func parser(foundCharacters string: String, forElementName elementName: String) {
        switch elementName {
        case "status":
            status = Status(rawValue: string) ?? .unknown
        case "unique_id":
            uniqueId = string
        case "code":
            code = string
        case "technical_message":
            technicalMessage = string
        case "message":
            message = string
        default:
            break
        }
    }

    func didEndParsing() {
        errorCode = GenesisError(code: code, technicalMessage: technicalMessage, message: message)
    }
}
