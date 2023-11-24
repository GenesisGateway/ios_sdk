//
//  WPFRequest.swift
//  GenesisSwift
//

import Foundation

final class WPFRequest: Request {

    override var path: String {
        Path.wpf.rawValue
    }

    override var httpBody: Data? {
        guard let request = parameters?["request"] as? PaymentRequest else { return nil }
        return request.toXmlString().data(using: .utf8)
    }

    override func processResponseString(_ string: String) -> Any? {
        WPFResponse(xmlString: string)
    }
}
