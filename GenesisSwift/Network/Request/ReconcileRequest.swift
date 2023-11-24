//
//  ReconcileRequest.swift
//  GenesisSwift
//

import Foundation

final class ReconcileRequest: Request {

    override var path: String {
        Path.reconcile.rawValue
    }

    override var httpBody: Data? {
        guard let uniqueId = parameters?["uniqueId"] as? String else { return nil }
        let reconcileRequest = Reconcile(uniqueId: uniqueId)
        return reconcileRequest.toXmlString().data(using: .utf8)
    }

    override func processResponseString(_ string: String) -> Any? {
        ReconcileResponse(xmlString: string)
    }
}
