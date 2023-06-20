//
//  PaymentRequest.swift
//  GenesisSwift
//

import UIKit

public final class PaymentRequest {

    public var transactionId: String
    public var amount: Decimal
    public var currency: CurrencyInfo
    public var customerEmail: String
    public var customerPhone: String?
    public var notificationUrl: String
    public var billingAddress: PaymentAddress
    public var transactionTypes: [PaymentTransactionType]

    //optional
    public var paymentDescription: String?
    public var shippingAddress: PaymentAddress?
    public var usage: String?
    public var riskParams: RiskParams?
    public var payLater: Bool?
    public var reminders: [Reminder]?
    public var crypto: Bool?
    public var gaming: Bool?
    public var consumerId: String?
    public var threeDSV2Params: ThreeDSV2Params?
    public var recurringType: RecurringType?
    public var recurringCategory: RecurringCategory?
    public var paymentSubtype: PaymentSubtype?
    public var paymentToken: String?
    public var birthDate: Date?
    public var documentId: String?
    public var remoteIp: String?
    public var businessAttributes: BusinessAttributes?
    public var dynamicDescriptorParams: DynamicDescriptorParams?

    public var additionalParameters: [String: String] = [:]

    let returnSuccessUrl = "https://WPFPaymentRequestSuccessUrl"
    let returnFailureUrl = "https://WPFPaymentRequestFailureUrl"
    let returnCancelUrl = "https://WPFPaymentRequestCancelUrl"

    /// Number of minutes determining how long the WPF will be valid. Will be set to 30 minutes by default. Valid value ranges between 1 minute and 31 days given in minutes
    public var lifetime: Int? {
        didSet {
            assert(oldValue == nil, "Variable lifetime can be set only once!")
        }
    }

    public var requires3DS: Bool {
        // the request requires 3DS if any of its specified types require it
        let types3DS: Set<TransactionName> = [.sale3d, .authorize3d, .initRecurringSale3d]
        return isParameterRequired(for: types3DS)
    }

    public var requiresRecurringType: Bool {
        // the request requires RecurringType if any of its specified types require it
        let requiredTypes: Set<TransactionName> = [.sale, .sale3d, .authorize, .authorize3d]
        return isParameterRequired(for: requiredTypes)
    }

    public var requiresRecurringCategory: Bool {
        // the request requires RecurringCategory if any of its specified types require it
        let requiredTypes: Set<TransactionName> = [.initRecurringSale, .initRecurringSale3d]
        return isParameterRequired(for: requiredTypes)
    }

    public var requiresPaymentSubtype: Bool {
        // the request requires PaymentSubtype if any of its specified types require it
        let requiredTypes: Set<TransactionName> = [.applePay]
        return isParameterRequired(for: requiredTypes)
    }

    /// Default initialization
    ///
    /// - Parameters:
    ///     - transactionId: Unique transaction id defined by merchant
    ///     - amount: Amount of transaction in minor currency unit
    ///     - currency: Currency code in ISO 4217
    ///     - customerEmail: Must contain valid e-mail of customer
    ///     - customerPhone: Must contain valid phone number of customer
    ///     - billingAddress: PaymentAddress
    ///     - transactionTypes: List of PaymentTransactionType
    ///     - notificationUrl: URL at merchant where gateway sends outcome of transaction
    ///
    public init(transactionId: String,
                amount: Decimal,
                currency: CurrencyInfo,
                customerEmail: String,
                customerPhone: String,
                billingAddress: PaymentAddress,
                transactionTypes: [PaymentTransactionType],
                notificationUrl: String) {

        self.transactionId = transactionId
        self.amount = amount
        self.currency = currency
        self.customerEmail = customerEmail
        self.customerPhone = customerPhone
        self.billingAddress = billingAddress
        self.transactionTypes = transactionTypes
        self.notificationUrl = notificationUrl
    }

    subscript(key: String) -> Any? {
        switch key {
        case AmountKey: return amount
        case TransactionIdKey: return transactionId
        case CurrencyKey: return currency.name.rawValue
        case UsageKey: return usage
        case PaymentDescriptionKey: return paymentDescription
        case CustomerEmailKey: return customerEmail
        case CustomerPhoneKey: return customerPhone
        case NotificationUrlKey: return notificationUrl
        case ReturnSuccessUrlKey: return returnSuccessUrl
        case ReturnFailureUrlKey: return returnFailureUrl
        case ReturnCancelUrlKey: return returnCancelUrl
        case BillingAddressKey: return billingAddress
        case ShippingAddressKey: return shippingAddress
        case TransactionTypesKey: return transactionTypes
        case RiskParamsKey: return riskParams
        case ThreeDSV2ParamsKey: return threeDSV2Params
        case DynamicDescriptorParamsKey: return dynamicDescriptorParams
        case LifetimeKey: return lifetime
        case PayLaterKey: return payLater
        case RemindersKey: return reminders
        case Crypto: return crypto
        case Gaming: return gaming
        case ConsumerId: return consumerId
        case RecurringTypeKey: return recurringType
        case RecurringCategoryKey: return recurringCategory
        case PaymentSubtypeKey: return paymentSubtype
        case PaymentTokenKey: return paymentToken
        case BirthDateKey: return birthDate
        case RemoteIpKey: return remoteIp
        case DocumentIdKey: return documentId
        case BusinessAttributesKey: return businessAttributes
        default: return nil
        }
    }
}

// MARK: - GenesisXmlObjectProtocol

extension PaymentRequest: GenesisXmlObjectProtocol {

    func propertyMap() -> [String: String] {
        [TransactionIdKey: "transaction_id",
        AmountKey: "amount",
        CurrencyKey: "currency",
        UsageKey: "usage",
        PaymentDescriptionKey: "description",
        CustomerEmailKey: "customer_email",
        CustomerPhoneKey: "customer_phone",
        NotificationUrlKey: "notification_url",
        ReturnSuccessUrlKey: "return_success_url",
        ReturnFailureUrlKey: "return_failure_url",
        ReturnCancelUrlKey: "return_cancel_url",
        BillingAddressKey: "billing_address",
        ShippingAddressKey: "shipping_address",
        TransactionTypesKey: "transaction_types",
        LifetimeKey: "lifetime",
        PayLaterKey: "pay_later",
        RemindersKey: "reminders",
        Crypto: "crypto",
        Gaming: "gaming",
        ConsumerId: "consumer_id",
        RiskParamsKey: "risk_params",
        ThreeDSV2ParamsKey: "threeds_v2_params",
        DynamicDescriptorParamsKey: "dynamic_descriptor_params",
        RecurringTypeKey: "recurring_type",
        RecurringCategoryKey: "recurring_category",
        BusinessAttributesKey: "business_attributes",
        PaymentSubtypeKey: "payment_subtype",
        PaymentTokenKey: "payment_token",
        BirthDateKey: "birth_date",
        RemoteIpKey: "remote_ip",
        DocumentIdKey: "document_id"]
    }

    func toXmlString() -> String {
        var xmlString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><wpf_payment>"
        for (key, value) in propertyMap() {
            guard let varValue = self[key] else { continue }

            let describing: String
            if key == AmountKey {
                guard let minorAmount = Currencies.convertToMinor(fromAmount: amount, andCurrency: currency.name) else { return "" }
                describing = minorAmount
            } else if let varValue = varValue as? Bool {
                describing = varValue ? "true" : "false"
            } else if let varValue = varValue as? [Any] {
                describing = varValue.toXmlString()
            } else if let structure = varValue as? GenesisDescriptionProtocol {
                describing = structure.description()
            } else {
                describing = String(describing: varValue)
            }

            xmlString += "<\(value)>" + describing + "</\(value)>"
        }

        for (key, value) in additionalParameters {
            xmlString += "<\(key)>" + value + "</\(key)>"
        }

        xmlString += "</wpf_payment>"

        let prettyXml = formatXml(xml: xmlString)
        return prettyXml ?? xmlString
    }

    private func formatXml(xml: String) -> String? {
        guard let regexNodes = try? NSRegularExpression(pattern: "<.*?>", options: .caseInsensitive) else { return nil }
        guard let regexOpenNode = try? NSRegularExpression(pattern: "<(?!/).*?>", options: .caseInsensitive) else { return nil }
        guard let regexCloseNode = try? NSRegularExpression(pattern: "</.*?>", options: .caseInsensitive) else { return nil }

        let range = NSMakeRange(0, xml.count)
        let modString = regexNodes.stringByReplacingMatches(in: xml, options: [], range: range, withTemplate: "\n$0\n")
        let allNodes = modString.split { $0 == "\n" }.map(String.init)

        var output = ""
        let indent = "  "
        var indentationCount = 0
        for (index, element) in allNodes.enumerated() {

            if index == 0 {
                output += element
                continue
            }
            if index == allNodes.count - 1 {
                output += "\n" + String(repeating: indent, count: indentationCount) + element
                continue
            }

            var matches = regexOpenNode.numberOfMatches(in: element, options: [], range: NSMakeRange(0, element.count))
            if matches == 1 {
                indentationCount += 1
                output += "\n" + String(repeating: indent, count: indentationCount) + element
                continue
            }

            matches = regexCloseNode.numberOfMatches(in: element, options: [], range: NSMakeRange(0, element.count))
            if matches == 1 {
                indentationCount -= 1
                output += element
                continue
            }

            output += element
        }

        return output
    }
}

// MARK: - ValidateInputDataProtocol

extension PaymentRequest: ValidateInputDataProtocol {

    public func isValidData() throws {
        let requiredParameters = RequiredParameters.requiredParametersForRequest(paymentRequest: self)
        let validator = RequiredParametersValidator(withRequiredParameters: requiredParameters)

        try validator.isValidRequest(request: self)
    }
}

extension Array where Element: GenesisXmlObjectProtocol {

    mutating func appendUpdateExclusive(element newAsset: Element) {
        append(newAsset)
    }
}

private extension Array {

    func toXmlString() -> String {
        var xmlString = ""
        for type in self {
            switch type {
            case let transactionType as PaymentTransactionType:
                xmlString += transactionType.toXmlString()
            case let reminder as Reminder:
                xmlString += reminder.toXmlString()
            default:
                break
            }
        }

        return xmlString
    }
}

private extension PaymentRequest {

    func isParameterRequired(for requiredTypes: Set<TransactionName>) -> Bool {
        for type in transactionTypes {
            if requiredTypes.contains(type.name) {
                return true
            }
        }
        return false
    }
}
