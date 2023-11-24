//
//  Credentials.swift
//  GenesisSwift
//
//  Created by Ivelin Tsankov eMerchantPay on 23.02.18.
//  Copyright © 2018 eMerchantPay. All rights reserved.
//

import Foundation

public class Credentials: NSObject {

    private(set) var username = ""
    private(set) var password = ""

    var encodedCredentialsBase64: String {
        stringToBase64String("\(username):\(password)")
    }

    public func setUsername(_ username: String) {
        self.username = username
    }

    public func setPassword(_ password: String) {
        self.password = password
    }

    public convenience init(withUsername username: String, andPassword password: String) {
        self.init()

        self.username = username
        self.password = password
    }

    private func stringToBase64String(_ string: String) -> String {
        Data(string.utf8).base64EncodedString()
    }
}
