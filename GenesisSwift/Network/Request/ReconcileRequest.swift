//
//  ReconcileRequest.swift
//  GenesisSwift
//

import Foundation

class ReconcileRequest: Request, RequestProtocol {
    func path() -> String {
        return Path.reconcile.rawValue
    }
    
    func httpBody() -> Data? {
        let reconcileRequest = Reconcile(uniqueId: self.parameters!["uniqueId"]! as! String)
        
        return reconcileRequest.toXmlString().data(using:.utf8)
    }
    
    func processingResponseString(string: String) -> Any? {
        let response = ReconcileResponse(xmlString: string)
        
        return response
    }
}
