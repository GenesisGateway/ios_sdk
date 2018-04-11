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
let DynamicDescriptorParamsKey = "dynamicDescriptorParams"
let LifetimeKey = "lifetime"
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

class RequiredParameters {
    
    static func requiredParametersForRequest(paymentRequest: PaymentRequest) -> [String] {
        let set = NSMutableSet()

        for transactionType in paymentRequest.transactionTypes {
            let transactionName = transactionType.name
            
            set.addObjects(from: requiredParametersForRequestWithTransactionName(transactionName: transactionName))
        }
        
        return set.allObjects as! [String]
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
        case .idebitPayin,
             .instaDebitPayin:
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
        return [ItemTypeKey,
                QuantityKey,
                UnitPriceKey,
                TotalAmountKey]
    }
    
    static func requiredParametersForAddress() -> [String] {
        return [FirstNameKey, LastNameKey, Address1Key, ZipCodeKey, CityKey, CountryKey, StateKey]
    }
    
    static private func requiredParametersForRequestWithTransactionName(transactionName: TransactionName) -> [String] {
        let defaultRequiredParameters = [TransactionIdKey, AmountKey, CurrencyKey, TransactionTypesKey, ReturnSuccessUrlKey, ReturnFailureUrlKey, ReturnCancelUrlKey, CustomerEmailKey, CustomerPhoneKey, BillingAddressKey, NotificationUrlKey]
        
        return defaultRequiredParameters
    }
}
