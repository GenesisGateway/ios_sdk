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
            if parameter == StateKey && !(address.country.alpha3 == "USA" || address.country.alpha3 == "CAN") {
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
            for p in error.paths {
                paths.append("\(path).\(p)")
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

        let transactionsNames: [TransactionName] = [.authorize, .authorize3d, .sale, .sale3d]
        return transactionTypes.first { transactionsNames.contains($0.name) } != nil
    }
    
    private func isURLParameter(parameter: String) -> Bool {
        parameter == NotificationUrlKey ||
        parameter == ReturnSuccessUrlKey ||
        parameter == ReturnFailureUrlKey ||
        parameter == ReturnCancelUrlKey
    }

    private func isIntervalWithinRange(_ interval: Int) -> Bool {
        Ranges.monthInMinutes.contains(interval)
    }
    
    private func isValidUrlString(string: String) -> Bool {
        guard !string.isEmpty, let url = URL(string: string), url.scheme != nil, !(url.scheme?.isEmpty)!, url.host != nil, !((url.host?.isEmpty)!) else {
            return false
        }
        return true
    }
    
    private func isValidValue(_ value: AnyObject, forParameter parameter: String) throws {
        let regex = ParametersRegex.regexForKey(parameter)

        if isURLParameter(parameter: parameter) {//URL
            guard let url = value as? String, isValidUrlString(string: url) else {
                throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
            }
        } else if parameter == ThreeDSV2ParamsKey {
            guard let _ = value as? ThreeDSV2Params else {
                throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
            }

        } else if parameter == AfterKey {
            guard let interval = value as? Int, isIntervalWithinRange(interval) else {
                throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
            }
        } else if let string = value as? String {//String
            guard !string.isEmpty else {
                throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
            }
            if !regex.isEmpty {
                guard evaluation(text: string, regex: regex) else {
                    throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
                }
            }
        } else if let decimal = value as? Decimal {//Decimal
            if parameter == AmountKey {
                guard decimal > 0 || decimal == 0 && isZeroAmountAllowed else {
                    throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
                }
            }
            guard decimal >= Decimal(0) else {
                throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
            }
        } else if let paymentAddress = value as? PaymentAddress {//PaymentAddress
            try paymentAddress.isValidData()
        } else if let isoCountryInfo = value as? IsoCountryInfo {//IsoCountryInfo
            if !regex.isEmpty {
                guard evaluation(text: isoCountryInfo.alpha2 , regex: regex) else {
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
        } else if value is RiskParams {//RiskParams
            return
        } else if value is Bool {//Bool
            return
        } else if value is CurrencyInfo {//CurrencyInfo
            return
        } else if value is RecurringType {//RecurringType
            return
        } else if value is RecurringCategory {//RecurringCategory
            return
        } else if value is PaymentSubtype {//PaymentSubtype
            return
        } else {
            assertionFailure("Unknown value type for \(parameter)")
        }
    }
    
    private func evaluation(text: String, regex: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let evaluation = predicate.evaluate(with: text)
        return evaluation
    }
}

private extension RequiredParametersValidator {
    enum Ranges {
        static let monthInMinutes = (1...44640)
    }
}
