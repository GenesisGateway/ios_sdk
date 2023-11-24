//
//  RequiredParametersValidator.swift
//  GenesisSwift
//

import Foundation

class RequiredParametersValidator {
    let parameters: [String]

    var path = ""
    var errorParameters: [String] = []
    var paths: [String] = []

    private var paymentRequest: PaymentRequest?

    init(withRequiredParameters parameters: [String]) {
        self.parameters = parameters
    }

    func isValidRequest(request: PaymentRequest) throws {
        path = "PaymentRequest"
        resetArrays()

        paymentRequest = request

        for parameter in parameters {
            catchErrorFor(parameter: parameter, withValue: request[parameter])
        }

        try throwErrorIfExists()
    }

    func isValidAddress(address: PaymentAddress) throws {
        path = "PaymentAddress"
        resetArrays()

        for parameter in parameters {
            if parameter == PropertyKeys.StateKey && !(address.country.alpha3 == "USA" || address.country.alpha3 == "CAN") {
                continue
            }

            catchErrorFor(parameter: parameter, withValue: address[parameter])
        }

        try throwErrorIfExists()
    }

    func isValidTransactionType(transactionType: PaymentTransactionType) throws {
        path = "PaymentTransactionTypes[\(transactionType.name)]"
        resetArrays()

        for parameter in parameters {
            catchErrorFor(parameter: parameter, withValue: transactionType[parameter])
        }

        try throwErrorIfExists()
    }

    func isValidKlarnaItem(item: KlarnaItem) throws {
        path = "items"
        resetArrays()

        for parameter in parameters {
            catchErrorFor(parameter: parameter, withValue: item[parameter])
        }

        try throwErrorIfExists()
    }

    func isValidReminder(reminder: Reminder) throws {
        path = "reminder"
        resetArrays()

        for parameter in parameters {
            catchErrorFor(parameter: parameter, withValue: reminder[parameter])
        }

        try throwErrorIfExists()
    }

    private func resetArrays() {
        errorParameters = []
        paths = []
    }

    private func catchErrorFor(parameter: String, withValue value: Any?) {
        guard let value = value as? AnyObject else {
            errorParameters.append(parameter)
            paths.append("\(path).\(parameter)")
            return
        }

        do {
            try isValidValue(value, forParameter: parameter)
        } catch {
            guard let error = error as? GenesisValidationError else {
                assertionFailure("Unexpected error type")
                return
            }
            errorParameters += error.parameters
            for param in error.paths {
                paths.append("\(path).\(param)")
            }
        }
    }

    private func throwErrorIfExists() throws {
        if errorParameters.count == 1 {
            throw GenesisValidationError.wrongValueForParameter(errorParameters.first!, paths.first!)
        } else if errorParameters.count > 1 {
            throw GenesisValidationError.wrongValueForParameters(errorParameters, paths)
        }
    }

    private var isZeroAmountAllowed: Bool {
        guard let transactionTypes = paymentRequest?.transactionTypes, !transactionTypes.isEmpty else { return false }

        let transactionsNames: Set<TransactionName> = [.authorize, .authorize3d, .sale, .sale3d]
        return !transactionsNames.isDisjoint(with: transactionTypes.map { $0.name })
    }

    private func isURLParameter(parameter: String) -> Bool {
        parameter == PropertyKeys.NotificationUrlKey ||
        parameter == PropertyKeys.ReturnSuccessUrlKey ||
        parameter == PropertyKeys.ReturnFailureUrlKey ||
        parameter == PropertyKeys.ReturnCancelUrlKey
    }

    private func isIntervalWithinRange(_ interval: Int) -> Bool {
        Ranges.monthInMinutes.contains(interval)
    }

    private func isValidUrlString(string: String) -> Bool {
        guard !string.isEmpty, let url = URL(string: string),
              let scheme = url.scheme, !scheme.isEmpty,
              let host = url.host, !host.isEmpty else { return false }
        return true
    }

    // swiftlint:disable cyclomatic_complexity
    private func isValidValue(_ value: AnyObject, forParameter parameter: String) throws {
        let regex = ParametersRegex.regexForKey(parameter)

        if isURLParameter(parameter: parameter) {
            guard let url = value as? String, isValidUrlString(string: url) else {
                throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
            }
        } else if parameter == PropertyKeys.ThreeDSV2ParamsKey {
            if !(value is ThreeDSV2Params) {
                throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
            }
        } else if parameter == PropertyKeys.AfterKey {
            guard let interval = value as? Int, isIntervalWithinRange(interval) else {
                throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
            }
        } else if let string = value as? String {
            guard !string.isEmpty else {
                throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
            }
            if !regex.isEmpty {
                guard evaluation(text: string, regex: regex) else {
                    throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
                }
            }
        } else if let decimal = value as? Decimal {
            if parameter == PropertyKeys.AmountKey {
                guard decimal > 0 || decimal == 0 && isZeroAmountAllowed else {
                    throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
                }
            }
            guard decimal >= Decimal(0) else {
                throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
            }
        } else if let paymentAddress = value as? PaymentAddress {
            try paymentAddress.isValidData()
        } else if let isoCountryInfo = value as? IsoCountryInfo {
            if !regex.isEmpty {
                guard evaluation(text: isoCountryInfo.alpha2, regex: regex) else {
                    throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
                }
            }
        } else if let transactionTypes = value as? [PaymentTransactionType] {// [PaymentTransactionType]
            for transactionType in transactionTypes {
                try transactionType.isValidData()
            }
        } else if let reminders = value as? [Reminder] {// [Reminder]
            for reminder in reminders {
                try reminder.isValidData()
            }
        } else if let klarmaItems = value as? [KlarnaItem] {// [KlarnaItem]
            for item in klarmaItems {
                try item.isValidData()
            }
        } else if value is RiskParams {
            return
        } else if value is Bool {
            return
        } else if value is CurrencyInfo {
            return
        } else if value is RecurringType {
            return
        } else if value is RecurringCategory {
            return
        } else if value is PaymentSubtype {
            return
        } else {
            assertionFailure("Unknown value type for \(parameter)")
        }
    }
    // swiftlint:enable cyclomatic_complexity

    private func evaluation(text: String, regex: String) -> Bool {
        assert(!text.isEmpty)
        assert(!regex.isEmpty)

        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let evaluation = predicate.evaluate(with: text)
        return evaluation
    }
}

private extension RequiredParametersValidator {
    enum Ranges {
        static let monthInMinutes = (1...31 * 24 * 60)
    }
}
