//
//  Reminder.swift
//  GenesisSwift
//
//  Created by Georgi Yanakiev emerchantpay on 23.03.23.
//  Copyright © 2023 eMerchantPay. All rights reserved.
//

import Foundation

public struct Reminder {

    public enum ReminderChannel: String, CaseIterable {
        case email
        case sms
    }

    public let channel: ReminderChannel
    public let after: Int

    public init(channel: ReminderChannel, after: Int) {
        self.channel = channel
        self.after = after
    }

    subscript(key: String) -> Any? {
        switch key {
        case ChannelKey: return channel
        case AfterKey: return after
        default: return nil
        }
    }
}

//MARK: GenesisDescriptionProtocol
extension Reminder: GenesisDescriptionProtocol {
    func description() -> String {
        toXmlString()
    }

}

// MARK: GenesisXmlObjectProtocol
extension Reminder: GenesisXmlObjectProtocol {
    func propertyMap() -> [String : String] {
        [ChannelKey: "channel",
         AfterKey: "after"]
    }

    func toXmlString() -> String {
        var xmlString = "<reminder>"
        for (key, value) in propertyMap() {
            guard let varValue = self[key] else { continue }
            xmlString += "<\(value)>" + String(describing: varValue) + "</\(value)>"
        }
        xmlString += "</reminder>"
        return xmlString
    }
}

// MARK: - ValidateInputDataProtocol

extension Reminder: ValidateInputDataProtocol {

    public func isValidData() throws {
        let requiredParamters = RequiredParameters.requiredParametersForReminder()
        let validator = RequiredParametersValidator(withRequiredParameters: requiredParamters)

        try validator.isValidReminder(reminder: self)
    }
}
