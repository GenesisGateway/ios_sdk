//
//  Reconcile.swift
//  GenesisSwift
//

import Foundation

class Reconcile {
    let uniqueId: String

    init(uniqueId: String) {
        self.uniqueId = uniqueId
    }
}

extension Reconcile: GenesisXmlObjectProtocol {

    func propertyMap() -> [String: String] {
        ["uniqueId": "unique_id"]
    }

    func toXmlString() -> String {
        let uniqueIdTagKey = propertyMap()["uniqueId"]!

        var xmlString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><wpf_reconcile>"
        xmlString += "<\(uniqueIdTagKey)>" + uniqueId + "</\(uniqueIdTagKey)>"
        xmlString += "</wpf_reconcile>"

        return xmlString
    }
}
