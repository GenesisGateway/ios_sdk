//
//  GenesisValidationError.swift
//  GenesisSwift
//

import Foundation

public enum GenesisValidationError: Error {
    case wrongValueForParameters([String], [String])
    case wrongValueForParameter(String, String)
}

extension GenesisValidationError: LocalizedError {
    public var errorDescription: String? {
        var string = ""

        switch self {
        case .wrongValueForParameters(let parameters, _):
            for parameter in parameters {
                if string.isEmpty {
                    string.append(parameter)
                } else {
                    string.append(", \(parameter)")
                }
            }
            return "Wrong value for \(string) required parameters."
        case .wrongValueForParameter(let parameter, _):
            return "Wrong value for \(parameter) required parameter."
        }
    }
}

extension GenesisValidationError: CustomNSError {
    public static var errorDomain: String { return "GenesisSwift" }
    public var errorUserInfo: [String: Any] { return ["parameters": parameters, "paths": paths] }

    public var parameters: [String] {
        switch self {
        case .wrongValueForParameters(let params, _): return params
        case .wrongValueForParameter(let param, _): return [param]
        }
    }

    public var paths: [String] {
        switch self {
        case .wrongValueForParameters(_, let paths): return paths
        case .wrongValueForParameter(_, let path): return [path]
        }
    }

    public var failureReason: String? { return localizedDescription }
}
