//
//  Credentials.swift
//  GenesisSwift
//
//  Created by Ivelin Tsankov eMerchantPay on 23.02.18.
//  Copyright © 2018 eMerchantPay. All rights reserved.
//

import Foundation

public class Credentials: NSObject {
//    MARK: protected properties
    var username: String = ""
    var password: String = ""
    
    var encodedCredentialsBase64: String {
        get {
            return self.stringToBase64String("\(self.username):\(self.password)")
        }
    }
    
    public func setUsername(username: String) {
        self.username = username
    }
    
    public func setPassword(password: String) {
        self.password = password
    }
    
    public convenience init(withUsername username: String, andPassword password: String) {
        self.init()
        
        self.username = username
        self.password = password
    }
    
    private func stringToBase64String(_ string: String) -> String {
        let utf8str = string.data(using: String.Encoding.utf8)
        return (utf8str?.base64EncodedString())!
    }
}
