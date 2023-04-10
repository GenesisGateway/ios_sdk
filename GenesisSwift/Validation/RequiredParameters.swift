//
//  RequiredParameters.swift
//  GenesisSwift
//

import Foundation

let TransactionIdKey = "transactionId"
let AmountKey = "amount"
let CurrencyKey = "currency"
let TransactionTypesKey = "transactionTypes"
let ReturnSuccessUrlKey = "returnSuccessUrl"
let ReturnFailureUrlKey = "returnFailureUrl"
let ReturnCancelUrlKey = "returnCancelUrl"
let CustomerEmailKey = "customerEmail"
let CustomerPhoneKey = "customerPhone"
let BillingAddressKey = "billingAddress"
let NotificationUrlKey = "notificationUrl"
let UsageKey = "usage"
let PaymentDescriptionKey = "paymentDescription"
let ShippingAddressKey = "shippingAddress"
let RiskParamsKey = "riskParams"
let ThreeDSV2ParamsKey = "threeDSV2Params"
let DynamicDescriptorParamsKey = "dynamicDescriptorParams"
let LifetimeKey = "lifetime"
let PayLater = "payLater"
let Crypto = "crypto"
let ConsumerId = "consumerId"
let Gaming = "gaming"
let FirstNameKey = "firstName"
let LastNameKey = "lastName"
let Address1Key = "address1"
let Address2Key = "address2"
let ZipCodeKey = "zipCode"
let CityKey = "city"
let CountryKey = "country"
let StateKey = "state"
let CustomerAccountIdKey = "customerAccountId"
let SourceWalletIdKey = "sourceWalletId"
let MerchantCustomerIdKey = "merchantCustomerId"
let ProductNameKey = "productName"
let ProductCategoryKey = "productCategory"
let CardTypeKey = "cardType"
let RedeemTypeKey = "redeemType"

let OrderTaxAmountKey = "orderTaxAmount"
let CustomerGenderKey = "customerGender"
let ItemsKey = "items"
let ItemTypeKey = "itemType"
let QuantityKey = "quantity"
let UnitPriceKey = "unitPrice"
let TotalAmountKey = "totalAmount"
let ManagedRecurringKey = "managedRecurring"
let RecurringTypeKey = "recurringType"
let RecurringCategoryKey = "recurringCategory"

let PaymentTokenKey = "paymentToken"
let PaymentSubtypeKey = "paymentSubtype"
let BirthDateKey = "birthDate"
let RemoteIpKey = "remoteIp"
let DocumentIdKey = "documentId"
let BusinessAttributesKey = "businessAttributes"
let EventStartDateKey = "eventStartDate"
let EventEndDateKey = "eventEndDate"
let EventOrganizerIdKey = "eventOrganizerId"
let EventIdKey = "eventId"
let DateOfOrderKey = "dateOfOrder"
let DeliveryDateKey = "deliveryDate"
let NameOfTheSupplierKey = "nameOfTheSupplier"
let MerchantNameKey = "merchantName"
let MerchantCityKey = "merchantCity"
let SubMerchantIdKey = "subMerchantId"

enum PropertyKeys {

    // 3DSv2 parameters' keys
    static let Control = "control"
    static let Purchase = "purchase"
    static let Recurring = "recurring"
    static let MerchantRisk = "merchant_risk"
    static let CardHolderAccount = "card_holder_account"
}

enum RequiredParameters {
    
    static func requiredParametersForRequest(paymentRequest: PaymentRequest) -> [String] {
        var set = Set<String>()

        for transactionType in paymentRequest.transactionTypes {
            set.formUnion(requiredParametersForRequestWithTransactionName(transactionName: transactionType.name))
        }

        // these parameters are not required to be present in the request, but they must be validated if they are
        if paymentRequest.consumerId?.isEmpty == false {
            set.insert(ConsumerId)
        }
        if paymentRequest.customerPhone?.isEmpty == false {
            set.insert(CustomerPhoneKey)
        }
        
        return Array(set)
    }
    
    static func requiredParametersForTransactionType(transactionType: PaymentTransactionType) -> [String] {
        switch transactionType.name {
        case .ppro:
            return [ProductNameKey,
                    ProductCategoryKey,
                    CardTypeKey,
                    RedeemTypeKey]
        case .citadelPayin:
            return [MerchantCustomerIdKey]
        case .idebitPayin, .instaDebitPayin:
            return [CustomerAccountIdKey]
        case .klarnaAuthorize:
            return [OrderTaxAmountKey,
                    CustomerGenderKey,
                    ItemsKey]
        default:
            return []
        }
    }
    
    static func requiredParametersForKlarnaItem() -> [String] {
        [ItemTypeKey, QuantityKey, UnitPriceKey, TotalAmountKey]
    }
    
    static func requiredParametersForAddress() -> [String] {
        [FirstNameKey, LastNameKey, CountryKey, StateKey]
    }
    
    static private func requiredParametersForRequestWithTransactionName(transactionName: TransactionName) -> [String] {
        var requiredParameters = [TransactionIdKey, AmountKey, CurrencyKey, TransactionTypesKey, ReturnSuccessUrlKey,
                                  ReturnFailureUrlKey, ReturnCancelUrlKey, CustomerEmailKey, BillingAddressKey, NotificationUrlKey]

        if [.authorize3d, .sale3d, .initRecurringSale3d].contains(transactionName) {
            requiredParameters.append(ThreeDSV2ParamsKey)
        }

        if [.authorize, .authorize3d, .sale, .sale3d].contains(transactionName) {
            debugPrint(transactionName)
            requiredParameters.append(RecurringTypeKey)
        }

        if [.initRecurringSale, .initRecurringSale3d].contains(transactionName) {
            requiredParameters.append(RecurringCategoryKey)
        }

        if [.applePay].contains(transactionName) {
            requiredParameters.append(contentsOf: [PaymentTokenKey, PaymentSubtypeKey, BirthDateKey, RemoteIpKey, DocumentIdKey, BusinessAttributesKey])
        }

        return requiredParameters
    }
}
