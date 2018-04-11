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
    case neteller
    case poli
    case p24
    case citadelPayin = "citadel_payin"
    case idebitPayin = "idebit_payin"
    case instaDebitPayin = "insta_debit_payin"
    case paypalExpress = "paypal_express"
    case webmoney
    case sddSale = "sdd_sale"
    case sddInitRecurringSale = "sdd_init_recurring_sale"
    case trustlySale = "trustly_sale"
    case trustlyWithdrawal = "trustly_withdrawal"
    case wechat
    case rpnPayment = "rpn_payment"
    case paysec
    case paysecPayout = "paysec_payout"
    case intersolve
    case fashioncheque
    case containerStore = "container_store"
    case neosurf
    case klarnaAuthorize = "klarna_authorize"
}

public final class PaymentTransactionType {
    public var name: TransactionName
    public var bin: String? // Card’s first 6 digits
    public var tail: String? // Card’s last 4 digits
    public var _isDefault: String? // Configure as default or not

    public var expirationDate: String? // Expiration month and year: YYYY-MM
    public var sourceWalletId: String?// Email address of consumer who owns the source wallet
    
    public var productName: String?//Apply to order product information in the process of payment, and the product description of purchase
    public var productCategory: String?//Type of commodity, includes 3C dig- its, clothing and shoes, bag and acces- sories, books and DVDS, tuition, reg- ister exam tuition, member fee, partic- ipation fee, logistic service, airline tick- ets, hotel catering, etc
    public var cardType: String?//Card type for the voucher - can be ’vir- tual’ or ’physical’ only
    public var redeemType: String?//Redeem type for the voucher - can be ’stored’ or ’instant’ only
    public var merchantCustomerId: String?//Identifier provided by the merchant that uniquely identifies the customer in their system
    public var customerAccountId: String?//Identifier provided by the merchant that uniquely identifies the consumer in their system
    public var productCode: String?//Product code
    public var productNum: String?//Product number
    public var productDesc: String?//Product description
    public var voucherNumber: String?//Voucher Number
    public var orderTaxAmount: Decimal?//Non-negative, minor units. The total tax amount of the order.
    public var customerGender: String?//Customer gender
    public var items: [KlarnaItem]?//List with items
    
    public var additionalParameters: [String:String] = [:]
    
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
            case SourceWalletIdKey: return sourceWalletId
            case ProductNameKey: return productName
            case ProductCategoryKey: return productCategory
            case CardTypeKey: return cardType
            case RedeemTypeKey: return redeemType
            case MerchantCustomerIdKey: return merchantCustomerId
            case CustomerAccountIdKey: return customerAccountId
            case "productCode": return productCode
            case "productNum": return productNum
            case "productDesc": return productDesc
            case "voucherNumber": return voucherNumber
            case OrderTaxAmountKey: return orderTaxAmount
            case CustomerGenderKey: return customerGender
            case ItemsKey: return items
            case "additionalParameters": return additionalParameters
            default: return nil
            }
        }
    }
}

extension PaymentTransactionType: ValidateInputDataProtocol {
    public func isValidData() throws {
        let requiredParameters = RequiredParameters.requiredParametersForTransactionType(transactionType: self)
        let validator = RequiredParametersValidator(withRequiredParameters: requiredParameters)
        
        do {
            try validator.isValidTransactionType(transactionType: self)
        } catch {
            throw error
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
            "expirationDate": "expiration_date",
            SourceWalletIdKey: "source_wallet_id",
            ProductNameKey: "product_name",
            ProductCategoryKey: "product_category",
            CardTypeKey: "card_type",
            RedeemTypeKey: "redeem_type",
            MerchantCustomerIdKey: "merchant_customer_id",
            CustomerAccountIdKey: "customer_account_id",
            "productCode": "product_code",
            "productNum": "product_num",
            "productDesc": "product_desc",
            "voucherNumber": "voucher_number",
            OrderTaxAmountKey: "order_tax_amount",
            CustomerGenderKey: "customer_gender",
            ItemsKey: "items",
            "marketplaceSellerInfo": "marketplace_seller_info"
        ]
    }
    
    func toXmlString() -> String {
        var xmlString = "<transaction_type name=\"\(name.rawValue)\""
        if (isDefault() != nil) {
            xmlString += " default=\"\(isDefault() as Optional))\""
        }
        xmlString += ">"
        for (key, value) in self.propertyMap() {
            if (key != "name" && key != "_isDefault") {
                guard let varValue = self[key] else { continue }
                
                if varValue is Array<KlarnaItem> {
                    xmlString += "<items>"
                    for item in varValue as! Array<KlarnaItem> {
                        xmlString += item.toXmlString()
                    }
                    xmlString += "</items>"
                } else if varValue is Decimal {
                    xmlString += "<\(value)>" + String(describing: varValue as! Decimal) + "</\(value)>"
                } else {
                    xmlString += "<\(value)>" + (varValue as! String) + "</\(value)>"
                }
            }
        }
        
        for (key, value) in additionalParameters {
            xmlString += "<\(key)>" + value + "</\(key)>"
        }
        
        xmlString += "</transaction_type>"
        return xmlString
    }
}
