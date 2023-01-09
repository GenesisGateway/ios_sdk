//
//  ManagedRecurringParams.swift
//  GenesisSwift
//
//  Created by Ivaylo Hadzhiev on 03.01.23.
//  Copyright © 2023 eMerchantPay. All rights reserved.
//

import Foundation

// MARK: - ManagedRecurringParams

public struct ManagedRecurringParams {

    public enum ModeValues {
        case automatic(Automatic) // the gateway will automatically manage the subsequent recurring transactions.
        case manual(Manual) // the merchant will manually manage the subsequent recurring transactions.
    }

    public let mode: ModeValues

    public init(mode: ModeValues) {
        self.mode = mode
    }
}

extension ManagedRecurringParams: GenesisDescriptionProtocol {
    func description() -> String {
        switch mode {
        case .automatic(let automatic):
            return automatic.description()
        case .manual(let manual):
            return manual.description()
        }
    }
}

// MARK: - Automatic

extension ManagedRecurringParams {

    public struct Automatic {

        public enum IntervalValues: String, CaseIterable {
            case days
            case months
        }

        public let period: Int // Rebill period in days(30) or months(12).
        public let interval: IntervalValues // The interval type for the period: days or months.
        public let firstDate: Date? // Specifies the date of the first recurring event in the future, default value is date of creation + period.
        public let timeOfDay: Int // Specifies the UTC hour in the day for the execution of the recurring transaction, default value 0.
        public let amount: Int? // Amount for the recurring transactions.
        public let maxCount: Int? // Maximum number of times a recurring will occur. Omit this parameter for unlimited recurring.

        public init(period: Int, interval: IntervalValues = .days, firstDate: Date? = nil,
                    timeOfDay: Int = 0, amount: Int? = nil, maxCount: Int? = nil) {
            self.period = period
            self.interval = interval
            self.firstDate = firstDate
            self.timeOfDay = timeOfDay
            self.amount = amount
            self.maxCount = maxCount
        }
    }
}

// MARK: - GenesisDescriptionProtocol

extension ManagedRecurringParams.Automatic: GenesisDescriptionProtocol, XMLConvertable {

    func description() -> String {
        var xmlString = ""
        xmlString += toXML(name: "mode", value: "automatic")
        xmlString += toXML(name: "interval", value: String(describing: interval.rawValue))
        xmlString += toXML(name: "first_date", value: firstDate?.iso8601Date)
        xmlString += toXML(name: "time_of_day", value: String(describing: timeOfDay))
        xmlString += toXML(name: "period", value: String(describing: period))
        if let amount = amount {
            xmlString += toXML(name: "amount", value: String(describing: amount))
        }
        if let maxCount = maxCount {
            xmlString += toXML(name: "max_count", value: String(describing: maxCount))
        }
        return xmlString
    }
}


// MARK: - Manual

extension ManagedRecurringParams {

    public struct Manual {

        public enum PaymentTypeValues: String, CaseIterable {
            case initial
            case subsequent
            case modification
            case cancellation
        }

        public enum AmountTypeValues: String, CaseIterable {
            case fixed
            case max
        }

        public enum FrequencyValues: String, CaseIterable {
            case daily
            case twiceWeekly = "twice_weekly"
            case weekly
            case tenDays = "ten_days"
            case fortnightly
            case monthly
            case everyTwoMonths = "every_two_months"
            case trimester
            case quarterly
            case twiceYearly = "twice_yearly"
            case annually
            case unscheduled
        }

        public let paymentType: PaymentTypeValues // Type of the current recurring transaction.
        public let amountType: AmountTypeValues // Type of the amount.
        public let frequency: FrequencyValues // Frequency of the subsequent transactions.
        public let registrationReferenceNumber: String // Reference number as per the agreement.
        public let maxAmount: Int // Maximum amount as per the agreement.
        public let maxCount: Int // Maximum transactions count as per the agreement. 99 - indicates infinite subsequent payments.
        public let validated: Bool // Indicates if the current transaction is valid as per the registered agreement.

        public init(paymentType: PaymentTypeValues, amountType: AmountTypeValues, frequency: FrequencyValues,
                    registrationReferenceNumber: String, maxAmount: Int, maxCount: Int, validated: Bool) {
            self.paymentType = paymentType
            self.amountType = amountType
            self.frequency = frequency
            self.registrationReferenceNumber = registrationReferenceNumber
            self.maxAmount = maxAmount
            self.maxCount = maxCount
            self.validated = validated
        }
    }
}

// MARK: - GenesisDescriptionProtocol

extension ManagedRecurringParams.Manual: GenesisDescriptionProtocol, XMLConvertable {

    func description() -> String {
        var xmlString = ""
        xmlString += toXML(name: "mode", value: "manual")
        xmlString += toXML(name: "payment_type", value: paymentType.rawValue)
        xmlString += toXML(name: "amount_type", value: amountType.rawValue)
        xmlString += toXML(name: "frequency", value: frequency.rawValue)
        xmlString += toXML(name: "registration_reference_number", value: registrationReferenceNumber)
        xmlString += toXML(name: "max_amount", value: String(describing: maxAmount))
        xmlString += toXML(name: "max_count", value: String(describing: maxCount))
        xmlString += toXML(name: "validated", value: validated ? "true" : "false")
        return xmlString
    }
}
