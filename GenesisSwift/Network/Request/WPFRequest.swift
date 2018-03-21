//
//  WPFRequest.swift
//  GenesisSwift
//

import Foundation

class WPFRequest: Request, RequestProtocol {
    func path() -> String {
        return Path.wpf.rawValue
    }
    
    func httpBody() -> Data? {
        let request = parameters!["request"] as! PaymentRequest
        
        return request.toXmlString().data(using:.utf8)!
    }
    
    func processingResponseString(string: String) -> Any? {
        let response = WPFResponse(xmlString: string)
        
        return response
    }
}
