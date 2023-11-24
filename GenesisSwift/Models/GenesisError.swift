//
//  GenesisErrorCode.swift
//  GenesisSwift
//

public enum GenesisErrorCode: String {
    case e401
    case e404
    case e426
    case e500
    case e503
    case eDataParsing
}

public struct GenesisError: Error {
    public let code: String?
    public let technicalMessage: String?
    public let message: String?

    init(code: String?, technicalMessage: String?, message: String?) {
        self.code = code
        self.technicalMessage = technicalMessage
        self.message = message
    }

    init(message: String) {
        self.code = ""
        self.technicalMessage = ""
        self.message = message
    }
}
