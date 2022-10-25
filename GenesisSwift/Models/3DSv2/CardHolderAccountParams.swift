//
//  CardHolderAccountParams.swift
//  GenesisSwift
//
//  Created by Ivaylo Hadzhiev on 14.10.22.
//  Copyright © 2022 eMerchantPay. All rights reserved.
//

import Foundation

public extension ThreeDSV2Params {

    struct CardHolderAccountParams {

        public enum UpdateIndicatorValues: String, CaseIterable {
            case currentTransaction = "current_transaction"
            case lessThan30Days = "less_than_30days"
            case between30To60Days = "30_to_60_days"
            case moreThan60Days = "more_than_60days"
        }

        public enum PasswordChangeIndicatorValues: String, CaseIterable {
            case noChange = "no_change"
            case duringTransaction = "during_transaction"
            case lessThan30Days = "less_than_30days"
            case between30To60Days = "30_to_60_days"
            case moreThan60Days = "more_than_60days"
        }

        public enum ShippingAddressUsageIndicatorValues: String, CaseIterable {
            case currentTransaction = "current_transaction"
            case lessThan30Days = "less_than_30days"
            case between30To60Days = "30_to_60_days"
            case moreThan60Days = "more_than_60days"
        }

        public enum SuspiciousActivityIndicatorValues: String, CaseIterable {
            case noSuspiciousObserved = "no_suspicious_observed"
            case suspiciousObserved = "suspicious_observed"
        }

        public enum RegistrationIndicatorValues: String, CaseIterable {
            case guestCheckout = "guest_checkout"
            case currentTransaction = "current_transaction"
            case lessThan30Days = "less_than_30days"
            case between30To60Days = "30_to_60_days"
            case moreThan60Days = "more_than_60days"
        }

        public var creationDate: Date?
        public var updateIndicator: UpdateIndicatorValues?
        public var lastChangeDate: Date?
        public var passwordChangeIndicator: PasswordChangeIndicatorValues?
        public var passwordChangeDate: Date?
        public var shippingAddressUsageIndicator: ShippingAddressUsageIndicatorValues?
        public var shippingAddressDateFirstUsed: Date?
        public var transactionsActivityLast24Hours: Int?
        public var transactionsActivityPreviousYear: Int?
        public var provisionAttemptsLast24Hours: Int?
        public var purchasesCountLast6Months: Int?
        public var suspiciousActivityIndicator: SuspiciousActivityIndicatorValues?
        public var registrationIndicator: RegistrationIndicatorValues?
        public var registrationDate: Date?

        public init(creationDate: Date? = nil,
                    updateIndicator: UpdateIndicatorValues? = nil,
                    lastChangeDate: Date? = nil,
                    passwordChangeIndicator: PasswordChangeIndicatorValues? = nil,
                    passwordChangeDate: Date? = nil,
                    shippingAddressUsageIndicator: ShippingAddressUsageIndicatorValues? = nil,
                    shippingAddressDateFirstUsed: Date? = nil,
                    transactionsActivityLast24Hours: Int? = nil,
                    transactionsActivityPreviousYear: Int? = nil,
                    provisionAttemptsLast24Hours: Int? = nil,
                    purchasesCountLast6Months: Int? = nil,
                    suspiciousActivityIndicator: SuspiciousActivityIndicatorValues? = nil,
                    registrationIndicator: RegistrationIndicatorValues? = nil,
                    registrationDate: Date? = nil) {
            self.creationDate = creationDate
            self.updateIndicator = updateIndicator
            self.lastChangeDate = lastChangeDate
            self.passwordChangeIndicator = passwordChangeIndicator
            self.passwordChangeDate = passwordChangeDate
            self.shippingAddressUsageIndicator = shippingAddressUsageIndicator
            self.shippingAddressDateFirstUsed = shippingAddressDateFirstUsed
            self.transactionsActivityLast24Hours = transactionsActivityLast24Hours
            self.transactionsActivityPreviousYear = transactionsActivityPreviousYear
            self.provisionAttemptsLast24Hours = provisionAttemptsLast24Hours
            self.purchasesCountLast6Months = purchasesCountLast6Months
            self.suspiciousActivityIndicator = suspiciousActivityIndicator
            self.registrationIndicator = registrationIndicator
            self.registrationDate = registrationDate
        }
    }
}

// MARK: - GenesisDescriptionProtocol

extension ThreeDSV2Params.CardHolderAccountParams: GenesisDescriptionProtocol, XMLConvertable {

    func description() -> String {
        var xmlString = ""

        xmlString += toXML(name: "creation_date", value: creationDate?.iso8601Date)
        xmlString += toXML(name: "update_indicator", value: updateIndicator?.rawValue)
        xmlString += toXML(name: "last_change_date", value: lastChangeDate?.iso8601Date)
        xmlString += toXML(name: "password_change_indicator", value: passwordChangeIndicator?.rawValue)
        xmlString += toXML(name: "password_change_date", value: passwordChangeDate?.iso8601Date)
        xmlString += toXML(name: "shipping_address_usage_indicator", value: shippingAddressUsageIndicator?.rawValue)
        xmlString += toXML(name: "shipping_address_date_first_used", value: shippingAddressDateFirstUsed?.iso8601Date)
        if let transactionsActivityLast24Hours = transactionsActivityLast24Hours {
            xmlString += toXML(name: "transactions_activity_last_24_hours", value: String(describing: transactionsActivityLast24Hours))
        }
        if let transactionsActivityPreviousYear = transactionsActivityPreviousYear {
            xmlString += toXML(name: "transactions_activity_previous_year", value: String(describing: transactionsActivityPreviousYear))
        }
        if let provisionAttemptsLast24Hours = provisionAttemptsLast24Hours {
            xmlString += toXML(name: "provision_attempts_last_24_hours", value: String(describing: provisionAttemptsLast24Hours))
        }
        if let purchasesCountLast6Months = purchasesCountLast6Months {
            xmlString += toXML(name: "purchases_count_last_6_months", value: String(describing: purchasesCountLast6Months))
        }
        xmlString += toXML(name: "suspicious_activity_indicator", value: suspiciousActivityIndicator?.rawValue)
        xmlString += toXML(name: "registration_indicator", value: registrationIndicator?.rawValue)
        xmlString += toXML(name: "registration_date", value: registrationDate?.iso8601Date)
        
        return xmlString
    }
}
