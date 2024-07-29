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

    // optional
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

    /// Number of minutes determining how long the WPF will be valid. Will be set to 30 minutes by default.
    /// Valid value ranges between 1 minute and 31 days given in minutes
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
        // .sale, .sale3d, .authorize & .authorize3d may contain a recurring type parameter, but it is not required
        // retain for backward compatibility and future requirements' changes
        false
    }

    public var requiresRecurringCategory: Bool {
        // .initRecurringSale & .initRecurringSale3d may contain a recurring category parameter, but it is not required
        // retain for backward compatibility and future requirements' changes
        false
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
        case PropertyKeys.AmountKey: return amount
        case PropertyKeys.TransactionIdKey: return transactionId
        case PropertyKeys.CurrencyKey: return currency.name.rawValue
        case PropertyKeys.UsageKey: return usage
        case PropertyKeys.PaymentDescriptionKey: return paymentDescription
        case PropertyKeys.CustomerEmailKey: return customerEmail
        case PropertyKeys.CustomerPhoneKey: return customerPhone
        case PropertyKeys.NotificationUrlKey: return notificationUrl
        case PropertyKeys.ReturnSuccessUrlKey: return returnSuccessUrl
        case PropertyKeys.ReturnFailureUrlKey: return returnFailureUrl
        case PropertyKeys.ReturnCancelUrlKey: return returnCancelUrl
        case PropertyKeys.BillingAddressKey: return billingAddress
        case PropertyKeys.ShippingAddressKey: return shippingAddress
        case PropertyKeys.TransactionTypesKey: return transactionTypes
        case PropertyKeys.RiskParamsKey: return riskParams
        case PropertyKeys.ThreeDSV2ParamsKey: return threeDSV2Params
        case PropertyKeys.DynamicDescriptorParamsKey: return dynamicDescriptorParams
        case PropertyKeys.LifetimeKey: return lifetime
        case PropertyKeys.PayLaterKey: return payLater
        case PropertyKeys.RemindersKey: return reminders
        case PropertyKeys.Crypto: return crypto
        case PropertyKeys.Gaming: return gaming
        case PropertyKeys.ConsumerId: return consumerId
        case PropertyKeys.RecurringCategoryKey: return recurringCategory
        case PropertyKeys.PaymentSubtypeKey: return paymentSubtype
        case PropertyKeys.PaymentTokenKey: return paymentToken
        case PropertyKeys.BirthDateKey: return birthDate
        case PropertyKeys.RemoteIpKey: return remoteIp
        case PropertyKeys.DocumentIdKey: return documentId
        case PropertyKeys.BusinessAttributesKey: return businessAttributes
        default: return nil
        }
    }
}

// MARK: - GenesisXmlObjectProtocol

extension PaymentRequest: GenesisXmlObjectProtocol {

    func propertyMap() -> [String: String] {
        [PropertyKeys.TransactionIdKey: "transaction_id",
         PropertyKeys.AmountKey: "amount",
         PropertyKeys.CurrencyKey: "currency",
         PropertyKeys.UsageKey: "usage",
         PropertyKeys.PaymentDescriptionKey: "description",
         PropertyKeys.CustomerEmailKey: "customer_email",
         PropertyKeys.CustomerPhoneKey: "customer_phone",
         PropertyKeys.NotificationUrlKey: "notification_url",
         PropertyKeys.ReturnSuccessUrlKey: "return_success_url",
         PropertyKeys.ReturnFailureUrlKey: "return_failure_url",
         PropertyKeys.ReturnCancelUrlKey: "return_cancel_url",
         PropertyKeys.BillingAddressKey: "billing_address",
         PropertyKeys.ShippingAddressKey: "shipping_address",
         PropertyKeys.TransactionTypesKey: "transaction_types",
         PropertyKeys.LifetimeKey: "lifetime",
         PropertyKeys.PayLaterKey: "pay_later",
         PropertyKeys.RemindersKey: "reminders",
         PropertyKeys.Crypto: "crypto",
         PropertyKeys.Gaming: "gaming",
         PropertyKeys.ConsumerId: "consumer_id",
         PropertyKeys.RiskParamsKey: "risk_params",
         PropertyKeys.ThreeDSV2ParamsKey: "threeds_v2_params",
         PropertyKeys.DynamicDescriptorParamsKey: "dynamic_descriptor_params",
         PropertyKeys.RecurringCategoryKey: "recurring_category",
         PropertyKeys.BusinessAttributesKey: "business_attributes",
         PropertyKeys.PaymentSubtypeKey: "payment_subtype",
         PropertyKeys.PaymentTokenKey: "payment_token",
         PropertyKeys.BirthDateKey: "birth_date",
         PropertyKeys.RemoteIpKey: "remote_ip",
         PropertyKeys.DocumentIdKey: "document_id"]
    }

    func toXmlString() -> String {
        var xmlString = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><wpf_payment>"
        for (key, value) in propertyMap() {
            guard let varValue = self[key] else { continue }

            let describing: String
            if key == PropertyKeys.AmountKey {
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

        let range = NSRange(location: 0, length: xml.count)
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

            var matches = regexOpenNode.numberOfMatches(in: element, options: [], range: NSRange(location: 0, length: element.count))
            if matches == 1 {
                indentationCount += 1
                output += "\n" + String(repeating: indent, count: indentationCount) + element
                continue
            }

            matches = regexCloseNode.numberOfMatches(in: element, options: [], range: NSRange(location: 0, length: element.count))
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

        try validator.validateRequest(self)
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
        for type in transactionTypes where requiredTypes.contains(type.name) {
            return true
        }
        return false
    }
}
