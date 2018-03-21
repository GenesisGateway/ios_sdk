//
//  PaymentTransactionType.swift
//  GenesisSwift
//

import UIKit

public enum TransactionName: String {
    case authorize
    case authorize3d
    case sale
    case sale3d
    case initRecurringSale = "init_recurring_sale"
    case initRecurringSale3d = "init_recurring_sale3d"
    case ezeewallet
    case sofort
    case cashu
    case paysafecard
    case ppro
    case paybyvoucherYeepay = "paybyvoucher_yeepay"
    case paybyvoucherSale = "paybyvoucher_sale"
    case neteller
    case poli
    case p24
    case citadelPayin = "citadel_payin"
    case idebitPayin = "idebit_payin"
    case instaDebitPayin = "insta_debit_payin"
    case paypalExpress = "paypal_express"
    case abnIdeal = "abn_ideal"
    case webmoney
    case inpay
    case sddSale = "sdd_sale"
    case sddInitRecurringSale = "sdd_init_recurring_sale"
    case trustlySale = "trustly_sale"
    case trustlyWithdrawal = "trustly_withdrawal"
    case wechat
}

public final class PaymentTransactionType {
    public var name: TransactionName
    var bin: String? // Card’s first 6 digits
    var tail: String? // Card’s last 4 digits
    private var _isDefault: String? // Configure as default or not

    var expirationDate: String? // Expiration month and year: YYYY-MM
    
    public init(name: TransactionName) {
        self.name = name
    }
    
    func isDefault(_ isDefault: Bool) {
        self._isDefault = isDefault ? "yes" : "no"
    }
    
    func isDefault() -> String? {
        return _isDefault
    }
    
    public var description: String {
        return self.toXmlString()
    }
    
    subscript(key: String) -> Any? {
        get {
            switch key {
            case "name": return name
            case "bin": return bin
            case "tail": return tail
            case "_isDefault": return _isDefault
            case "expirationDate": return expirationDate
            default: return nil
            }
        }
    }
}

// MARK: GenesisXmlObjectProtocol
extension PaymentTransactionType: GenesisXmlObjectProtocol {
    
    func propertyMap() -> ([String : String]) {
        return [
            "name": "name",
            "bin": "bin",
            "tail": "tail",
            "_isDefault": "default",
            "expirationDate": "expiration_date"]
    }
    
    func toXmlString() -> String {
        var xmlString = "<transaction_type name=\"\(name)\""
        if (isDefault() != nil) {
            xmlString += " default=\"\(isDefault() as Optional))\""
        }
        xmlString += ">"
        for (key, value) in self.propertyMap() {
            if (key != "name" && key != "_isDefault") {
                guard let varValue = self[key] else { continue }
                xmlString += "<\(value)>" + (varValue as! String) + "</\(value)>"
            }
        }
        xmlString += "</transaction_type>"
        return xmlString
    }
}
