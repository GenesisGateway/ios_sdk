//
//  PaymentTransactionType.swift
//  GenesisSwift
//

import Foundation

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
    case applePay = "apple_pay"
}

extension PropertyKeys {
    static let NameKey = "name"
    static let BinKey = "bin"
    static let TailKey = "tail"
    static let IsDefaultKey = "_isDefault"
    static let ExpirationDateKey = "expirationDate"
    static let ProductCodeKey = "productCode"
    static let ProductNumKey = "productNum"
    static let ProductDescKey = "productDesc"
    static let VoucherNumberKey = "voucherNumber"
    static let AdditionalParametersKey = "additionalParameters"
}

public final class PaymentTransactionType {
    public var name: TransactionName
    public var bin: String? // Card’s first 6 digits
    public var tail: String? // Card’s last 4 digits
    public var _isDefault: String? // Configure as default or not

    public var expirationDate: String? // Expiration month and year: YYYY-MM
    public var sourceWalletId: String? // Email address of consumer who owns the source wallet
    public var productName: String? // Apply to order product information in the process of payment, and the product description of purchase

    // Type of commodity, includes 3C dig- its, clothing and shoes, bag and acces- sories, books and DVDS, tuition,
    // reg- ister exam tuition, member fee, partic- ipation fee, logistic service, airline tick- ets, hotel catering, etc
    public var productCategory: String?
    public var cardType: String? // Card type for the voucher - can be ’vir- tual’ or ’physical’ only
    public var redeemType: String? // Redeem type for the voucher - can be ’stored’ or ’instant’ only
    public var merchantCustomerId: String? // Identifier provided by the merchant that uniquely identifies the customer in their system
    public var customerAccountId: String? // Identifier provided by the merchant that uniquely identifies the consumer in their system
    public var productCode: String? // Product code
    public var productNum: String? // Product number
    public var productDesc: String? // Product description
    public var voucherNumber: String? // Voucher Number
    public var orderTaxAmount: Decimal? // Non-negative, minor units. The total tax amount of the order.
    public var customerGender: String? // Customer gender
    public var items: [KlarnaItem]? // List with items
    public var additionalParameters: [String: String] = [:]
    public var managedRecurring: ManagedRecurringParams?
    public var recurringType: RecurringType?

    public init(name: TransactionName) {
        self.name = name
    }

    func isDefault(_ isDefault: Bool) {
        _isDefault = isDefault ? "yes" : "no"
    }

    func isDefault() -> String? {
        _isDefault
    }

    public var description: String {
        toXmlString()
    }

    subscript(key: String) -> Any? {
        switch key {
        case PropertyKeys.NameKey: return name
        case PropertyKeys.BinKey: return bin
        case PropertyKeys.TailKey: return tail
        case PropertyKeys.IsDefaultKey: return _isDefault
        case PropertyKeys.ExpirationDateKey: return expirationDate
        case PropertyKeys.SourceWalletIdKey: return sourceWalletId
        case PropertyKeys.ProductNameKey: return productName
        case PropertyKeys.ProductCategoryKey: return productCategory
        case PropertyKeys.CardTypeKey: return cardType
        case PropertyKeys.RedeemTypeKey: return redeemType
        case PropertyKeys.MerchantCustomerIdKey: return merchantCustomerId
        case PropertyKeys.CustomerAccountIdKey: return customerAccountId
        case PropertyKeys.ProductCodeKey: return productCode
        case PropertyKeys.ProductNumKey: return productNum
        case PropertyKeys.ProductDescKey: return productDesc
        case PropertyKeys.VoucherNumberKey: return voucherNumber
        case PropertyKeys.OrderTaxAmountKey: return orderTaxAmount
        case PropertyKeys.CustomerGenderKey: return customerGender
        case PropertyKeys.ItemsKey: return items
        case PropertyKeys.AdditionalParametersKey: return additionalParameters
        case PropertyKeys.ManagedRecurringKey: return managedRecurring
        case PropertyKeys.RecurringTypeKey: return recurringType
        default: return nil
        }
    }
}

// MARK: - ValidateInputDataProtocol

extension PaymentTransactionType: ValidateInputDataProtocol {

    public func isValidData() throws {
        let requiredParameters = RequiredParameters.requiredParametersForTransactionType(transactionType: self)
        let validator = RequiredParametersValidator(withRequiredParameters: requiredParameters)

        try validator.isValidTransactionType(transactionType: self)
    }
}

// MARK: - GenesisXmlObjectProtocol

extension PaymentTransactionType: GenesisXmlObjectProtocol {

    func propertyMap() -> [String: String] {
        [PropertyKeys.NameKey: "name",
         PropertyKeys.BinKey: "bin",
         PropertyKeys.TailKey: "tail",
         PropertyKeys.IsDefaultKey: "default",
         PropertyKeys.ExpirationDateKey: "expiration_date",
         PropertyKeys.SourceWalletIdKey: "source_wallet_id",
         PropertyKeys.ProductNameKey: "product_name",
         PropertyKeys.ProductCategoryKey: "product_category",
         PropertyKeys.CardTypeKey: "card_type",
         PropertyKeys.RedeemTypeKey: "redeem_type",
         PropertyKeys.MerchantCustomerIdKey: "merchant_customer_id",
         PropertyKeys.CustomerAccountIdKey: "customer_account_id",
         PropertyKeys.ProductCodeKey: "product_code",
         PropertyKeys.ProductNumKey: "product_num",
         PropertyKeys.ProductDescKey: "product_desc",
         PropertyKeys.VoucherNumberKey: "voucher_number",
         PropertyKeys.OrderTaxAmountKey: "order_tax_amount",
         PropertyKeys.CustomerGenderKey: "customer_gender",
         PropertyKeys.ItemsKey: "items",
         PropertyKeys.ManagedRecurringKey: "managed_recurring",
         PropertyKeys.RecurringTypeKey: "recurring_type"]
    }

    func toXmlString() -> String {
        var xmlString = "<transaction_type name=\"\(name.rawValue)\""
        if isDefault() != nil {
            xmlString += " default=\"\(isDefault() as Optional))\""
        }
        xmlString += ">"
        for (key, value) in propertyMap() {
            guard key != PropertyKeys.NameKey && key != PropertyKeys.IsDefaultKey else { continue }
            guard let varValue = self[key] else { continue }

            if let items = varValue as? [KlarnaItem] {
                xmlString += "<items>"
                for item in items {
                    xmlString += item.toXmlString()
                }
                xmlString += "</items>"
            } else if let decimal = varValue as? Decimal {
                xmlString += "<\(value)>" + String(describing: decimal) + "</\(value)>"
            } else if let managedRecurringParams = varValue as? ManagedRecurringParams {
                xmlString += "<\(value)>\(managedRecurringParams.description())</\(value)>"
            } else if let recurringType = varValue as? RecurringType {
                xmlString += "<\(value)>\(recurringType.description())</\(value)>"
            } else if let string = varValue as? String {
                xmlString += "<\(value)>" + string + "</\(value)>"
            }
        }

        for (key, value) in additionalParameters {
            xmlString += "<\(key)>" + value + "</\(key)>"
        }

        xmlString += "</transaction_type>"
        return xmlString
    }
}
