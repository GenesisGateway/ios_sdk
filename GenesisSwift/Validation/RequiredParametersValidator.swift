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
    
    init(withRequiredParameters parameters: [String]) {
        self.parameters = parameters
    }
    
    func isValidRequest(request: PaymentRequest) throws {
        path = "PaymentRequest"
        resetArrays()
        
        for parameter in parameters {
            catchErrorFor(parameter: parameter, withValue: request[parameter])
        }
        
        do {
            try throwErrorIfExists()
        } catch {
            throw error
        }
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
        
        do {
            try throwErrorIfExists()
        } catch {
            throw error
        }
    }
    
    func isValidTransactionType(transactionType: PaymentTransactionType) throws {
        path = "PaymentTransactionTypes[\(transactionType.name)]"
        resetArrays()
        
        for parameter in parameters {
            catchErrorFor(parameter: parameter, withValue: transactionType[parameter])
        }
        
        do {
            try throwErrorIfExists()
        } catch {
            throw error
        }
    }
    
    func isValidKlarnaItem(item: KlarnaItem) throws {
        path = "items"
        resetArrays()
        
        for parameter in parameters {
            catchErrorFor(parameter: parameter, withValue: item[parameter])
        }
        
        do {
            try throwErrorIfExists()
        } catch {
            throw error
        }
    }
    
    private func resetArrays() {
        errorParameters = []
        paths = []
    }
    
    private func catchErrorFor(parameter: String, withValue value: Any?) {
        guard value != nil else {
            errorParameters.append(parameter)
            paths.append("\(path).\(parameter)")
            return
        }
        
        do {
            try isValidValue(value: value! as AnyObject, forParameter: parameter)
        } catch {
            errorParameters += (error as! GenesisValidationError).parameters
            for p in (error as! GenesisValidationError).paths {
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
    
    private func isURLParameter(parameter: String) -> Bool {
        return parameter == NotificationUrlKey || parameter == ReturnSuccessUrlKey || parameter == ReturnFailureUrlKey || parameter == ReturnCancelUrlKey
    }
    
    private func isValidUrlString(string: String) -> Bool {
        guard !string.isEmpty, let url = URL(string: string), url.scheme != nil, !(url.scheme?.isEmpty)!, url.host != nil, !((url.host?.isEmpty)!) else {
            return false
        }
        
        return true
    }
    
    private func isValidValue(value: AnyObject, forParameter parameter: String) throws {
        let regex = ParametersRegex.regexForKey(key: parameter)

        if isURLParameter(parameter: parameter) {//URL
            guard isValidUrlString(string: value as! String) else {
                throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
            }
        } else if value is String {//String
            guard !(value as! String).isEmpty else {
                throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
            }
            
            if !regex.isEmpty {
                guard evaluation(text: (value as! String), regex: regex) else {
                    throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
                }
            }
        } else if value is Decimal {//Decimal
            if parameter == AmountKey {
                guard (value as! Decimal) > Decimal(0) else {
                    throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
                }
            }
            
            guard (value as! Decimal) >= Decimal(0) else {
                throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
            }
        } else if value is PaymentAddress {//PaymentAddress
            do {
                try (value as! PaymentAddress).isValidData()
            } catch {
                throw error
            }
        } else if value is IsoCountryInfo {//IsoCountryInfo
            if !regex.isEmpty {
                guard evaluation(text: (value as! IsoCountryInfo).alpha2 , regex: regex) else {
                    throw GenesisValidationError.wrongValueForParameter(parameter, parameter)
                }
            }
        } else if value is Array<PaymentTransactionType> {//Array PaymentTransactionType
            for transactionType in value as! Array<PaymentTransactionType> {
                do {
                    try transactionType.isValidData()
                } catch {
                    throw error
                }
            }
        } else if value is Array<KlarnaItem> {//Array PaymentTransactionType
            for item in value as! Array<KlarnaItem> {
                do {
                    try item.isValidData()
                } catch {
                    throw error
                }
            }
        } else if value is Array<String> {//Array String
            assert(false)
        } else if value is Array<Any> {//Array Any
            assert(false)
        } else if value is RiskParams {//RiskParams
            return
        } else if value is Bool {//Bool
            return
        } else if value is CurrencyInfo {//CurrencyInfo
            return
        } else {//unknown
            assert(false)
        }
    }
    
    private func evaluation(text: String, regex: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let evaluation = predicate.evaluate(with: text)
        return evaluation
    }
}
