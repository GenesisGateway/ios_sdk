//
//  RequiredParameters.swift
//  GenesisSwift
//

import Foundation

enum PropertyKeys {

    static let TransactionIdKey = "transactionId"
    static let AmountKey = "amount"
    static let CurrencyKey = "currency"
    static let TransactionTypesKey = "transactionTypes"
    static let ReturnSuccessUrlKey = "returnSuccessUrl"
    static let ReturnFailureUrlKey = "returnFailureUrl"
    static let ReturnCancelUrlKey = "returnCancelUrl"
    static let CustomerEmailKey = "customerEmail"
    static let CustomerPhoneKey = "customerPhone"
    static let BillingAddressKey = "billingAddress"
    static let NotificationUrlKey = "notificationUrl"
    static let UsageKey = "usage"
    static let PaymentDescriptionKey = "paymentDescription"
    static let ShippingAddressKey = "shippingAddress"
    static let RiskParamsKey = "riskParams"
    static let ThreeDSV2ParamsKey = "threeDSV2Params"
    static let DynamicDescriptorParamsKey = "dynamicDescriptorParams"
    static let LifetimeKey = "lifetime"
    static let PayLaterKey = "payLater"
    static let Crypto = "crypto"
    static let ConsumerId = "consumerId"
    static let Gaming = "gaming"
    static let FirstNameKey = "firstName"
    static let LastNameKey = "lastName"
    static let Address1Key = "address1"
    static let Address2Key = "address2"
    static let ZipCodeKey = "zipCode"
    static let CityKey = "city"
    static let CountryKey = "country"
    static let StateKey = "state"
    static let CustomerAccountIdKey = "customerAccountId"
    static let SourceWalletIdKey = "sourceWalletId"
    static let MerchantCustomerIdKey = "merchantCustomerId"
    static let ProductNameKey = "productName"
    static let ProductCategoryKey = "productCategory"
    static let CardTypeKey = "cardType"
    static let RedeemTypeKey = "redeemType"

    static let OrderTaxAmountKey = "orderTaxAmount"
    static let CustomerGenderKey = "customerGender"
    static let ItemsKey = "items"
    static let ItemTypeKey = "itemType"
    static let QuantityKey = "quantity"
    static let UnitPriceKey = "unitPrice"
    static let TotalAmountKey = "totalAmount"
    static let ManagedRecurringKey = "managedRecurring"
    static let RecurringTypeKey = "recurringType"
    static let RecurringCategoryKey = "recurringCategory"

    static let PaymentTokenKey = "paymentToken"
    static let PaymentSubtypeKey = "paymentSubtype"
    static let BirthDateKey = "birthDate"
    static let RemoteIpKey = "remoteIp"
    static let DocumentIdKey = "documentId"
    static let BusinessAttributesKey = "businessAttributes"
    static let EventStartDateKey = "eventStartDate"
    static let EventEndDateKey = "eventEndDate"
    static let EventOrganizerIdKey = "eventOrganizerId"
    static let EventIdKey = "eventId"
    static let DateOfOrderKey = "dateOfOrder"
    static let DeliveryDateKey = "deliveryDate"
    static let NameOfTheSupplierKey = "nameOfTheSupplier"
    static let MerchantNameKey = "merchantName"
    static let MerchantCityKey = "merchantCity"
    static let MerchantCountryKey = "merchantCountry"
    static let MerchantStateKey = "merchantState"
    static let MerchantZipCodeKey = "merchantZipCode"
    static let MerchantAddressKey = "merchantAddress"
    static let MerchantUrlKey = "merchantUrl"
    static let MerchantPhoneKey = "merchantPhone"
    static let MerchantServiceCityKey = "merchantServiceCity"
    static let MerchantServiceCountryKey = "merchantServiceCountry"
    static let MerchantServiceStateKey = "merchantServiceState"
    static let MerchantServiceZipCodeKey = "merchantServiceZipCode"
    static let MerchantServicePhoneKey = "merchantServicePhone"
    static let SubMerchantIdKey = "subMerchantId"
    static let MerchantGeoCoordinatesKeys = "merchantGeoCoordinates"
    static let MerchantServiceGeoCoordinatesKey = "merchantServiceGeoCoordinates"
    static let RemindersKey = "reminders"
    static let ChannelKey = "channel"
    static let AfterKey = "after"

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
            set.insert(PropertyKeys.ConsumerId)
        }
        if paymentRequest.customerPhone?.isEmpty == false {
            set.insert(PropertyKeys.CustomerPhoneKey)
        }
        if paymentRequest.payLater == true {
            set.insert(PropertyKeys.RemindersKey)
        }

        return Array(set)
    }

    static func requiredParametersForTransactionType(_ transactionType: PaymentTransactionType) -> [String] {
        switch transactionType.name {
        case .ppro:
            return [PropertyKeys.ProductNameKey,
                    PropertyKeys.ProductCategoryKey,
                    PropertyKeys.CardTypeKey,
                    PropertyKeys.RedeemTypeKey]
        case .citadelPayin:
            return [PropertyKeys.MerchantCustomerIdKey]
        case .idebitPayin, .instaDebitPayin:
            return [PropertyKeys.CustomerAccountIdKey]
        case .klarnaAuthorize:
            return [PropertyKeys.OrderTaxAmountKey,
                    PropertyKeys.CustomerGenderKey,
                    PropertyKeys.ItemsKey]
        default:
            return []
        }
    }

    static func requiredParametersForKlarnaItem() -> [String] {
        [PropertyKeys.ItemTypeKey, PropertyKeys.QuantityKey, PropertyKeys.UnitPriceKey, PropertyKeys.TotalAmountKey]
    }

    static func requiredParametersForAddress() -> [String] {
        [PropertyKeys.FirstNameKey, PropertyKeys.LastNameKey, PropertyKeys.CountryKey, PropertyKeys.StateKey]
    }

    static func requiredParametersForReminder() -> [String] {
        [PropertyKeys.AfterKey]
    }

    private static func requiredParametersForRequestWithTransactionName(transactionName: TransactionName) -> [String] {
        var requiredParameters = [PropertyKeys.TransactionIdKey, PropertyKeys.AmountKey, PropertyKeys.CurrencyKey,
                                  PropertyKeys.TransactionTypesKey, PropertyKeys.ReturnSuccessUrlKey,
                                  PropertyKeys.ReturnFailureUrlKey, PropertyKeys.ReturnCancelUrlKey, PropertyKeys.CustomerEmailKey,
                                  PropertyKeys.BillingAddressKey, PropertyKeys.NotificationUrlKey]

        if [.authorize3d, .sale3d, .initRecurringSale3d].contains(transactionName) {
            requiredParameters.append(PropertyKeys.ThreeDSV2ParamsKey)
        }

        if [.applePay].contains(transactionName) {
            requiredParameters.append(contentsOf: [PropertyKeys.PaymentSubtypeKey])
        }

        return requiredParameters
    }
}
