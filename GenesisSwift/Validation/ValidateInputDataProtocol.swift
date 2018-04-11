//
//  ValidateInputDataProtocol.swift
//  GenesisSwift
//

import Foundation

public protocol ValidateInputDataProtocol {
    func isValidData() throws
    func evaluation(text: String, regex: String) -> Bool
}

extension ValidateInputDataProtocol {
    public func evaluation(text: String, regex: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        let evaluation = predicate.evaluate(with: text)
        return evaluation
    }
}
