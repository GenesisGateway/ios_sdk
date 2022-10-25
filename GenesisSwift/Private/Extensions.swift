//
//  GenesisHelpers.swift
//  GenesisSwift
//

import Foundation

extension Formatter {

    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()

    static let iso8601Date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
}

public extension Date {

    var iso8601: String {
        Formatter.iso8601.string(from: self)
    }

    var iso8601Date: String {
        Formatter.iso8601Date.string(from: self)
    }
}

public extension String {

    var dateFromISO8601: Date? {
        Formatter.iso8601.date(from: self)
    }

    var dateFromISO8601Date: Date? {
        Formatter.iso8601Date.date(from: self)
    }

    func toBase64() -> String {
        Data(self.utf8).base64EncodedString()
    }
}
