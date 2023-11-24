//
//  DataProtocol.swift
//  GenesisSwift
//

import Foundation

public protocol DataProtocol {
    var title: String { get set }
    var value: String { get set }
    var regex: String { get set }
}

public extension DataProtocol {

    var regex: String {
        get {
            ""
        }

        // swiftlint:disable unused_setter_value
        set {
            // do nothing
        }
        // swiftlint:enable unused_setter_value
    }
}
