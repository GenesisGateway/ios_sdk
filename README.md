# Genesis iOS SDK
>

[![Build Status](https://img.shields.io/travis/GenesisGateway/ios_sdk.svg?style=flat)](https://travis-ci.org/GenesisGateway/ios_sdk)

## Table of Contents
- [Requirements](#requirements)
- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Additional Usage](#additional-usage)
- [Required parameters for transaction types](#required-parameters-for-transaction-types)

## Requirements

- iOS 12.0+
- Xcode 10.0+

## Installation

GenesisSwift requires Swift 5, so make sure you have at least [Xcode 10](https://developer.apple.com/xcode/downloads/).

### CocoaPods

In your `Podfile`:

    pod 'GenesisSwift'

### Carthage

In your `Cartfile`:

    git "https://github.com/GenesisGateway/ios_sdk"

### Git Submodule

1. Clone GenesisSwift as a submodule into the directory of your choice, in this case Libraries/GenesisSwift:
    ```
    git submodule add https://github.com/GenesisGateway/ios_sdk Libraries/GenesisSwift
    git submodule update --init
    ```

2. Drag `GenesisSwift.xcodeproj` into your project tree as a subproject.

3. Under your project's Build Phases, expand Target Dependencies. Click the + button and add GenesisSwift.

4. Expand the Link Binary With Libraries phase. Click the + button and add GenesisSwift.

5. Click the + button in the top left corner to add a Copy Files build phase. Set the directory to Frameworks. Click the + button and add GenesisSwift.

## Basic Usage

```swift
import GenesisSwift

...

//PaymentAddress for Genesis
let paymentAddress = PaymentAddress(firstName: firstName,
                                       lastName: lastName,
                                       address1: address1,
                                       address2: address2,
                                       zipCode: zipCode,
                                       city: city,
                                       state: state,
                                       country: IsoCountryCodes.search(byName: "United States"))

//PaymentTransactionType for Genesis
let paymentTransactionType = PaymentTransactionType(name: .sale)

//PaymentRequest for Genesis
let paymentRequest = PaymentRequest(transactionId: transactionId,
                                       amount: amount.explicitConvertionToDecimal()!,
                                       currency: Currencies().USD,
                                       customerEmail: customerEmail,
                                       customerPhone: customerPhone,
                                       billingAddress: paymentAddress,
                                       transactionTypes: [paymentTransactionType],
                                       notificationUrl: notificationUrl)

//Credentials for Genesis
let credentials = Credentials(withUsername: "YOUR_USERNAME", andPassword: "YOUR_PASSWORD")

//Configuration for Genesis
let configuration = Configuration(credentials: credentials, language: .en, environment: .staging, endpoint: .emerchantpay)

//Init Genesis with Configuration and WPFPaymentRequest
let genesis = Genesis(withConfiguration: configuration, paymentRequest: paymentRequest, forDelegate: self)


//show Genesis payment form

//Push to navigation controller
genesis.push(toNavigationController: navigationController!, animated: true)

//Present to modal view
genesis.present(toViewController: self, animated: true)

//Use genesis.genesisViewController() and show how you want
guard let genesisViewController = genesis.genesisViewController() else {
    return
}
show(genesisViewController, sender: nil)


...

// MARK: - GenesisDelegate
extension YourViewController: GenesisDelegate {

    func genesisDidFinishLoading(userInfo: [AnyHashable: Any]) {
        print("Loading transaction: \(userInfo[GenesisInfoKeys.uniqueId]!)")
        ...
    }

    func genesisDidEndWithSuccess(userInfo: [AnyHashable: Any]) {
        print("""
        Transaction succeeded
        uniqueId: \(userInfo[GenesisInfoKeys.uniqueId]!),
        status: \(userInfo[GenesisInfoKeys.status]!),
        transactionId: \(userInfo[GenesisInfoKeys.transactionId]!),
        timestamp: \((userInfo[GenesisInfoKeys.timestamp] as? Date)!),
        amount: \((userInfo[GenesisInfoKeys.timestamp] as? Double)!),
        currency: \(userInfo[GenesisInfoKeys.currency]!)
        """)
        ...
    }

    func genesisDidEndWithCancel(userInfo: [AnyHashable: Any]) {
        print("Transaction cancelled: \(userInfo[GenesisInfoKeys.uniqueId]!)")
        ...
    }

    func genesisDidEndWithFailure(userInfo: [AnyHashable: Any], errorCode: GenesisError) {
        print("Transaction failed: \(userInfo[GenesisInfoKeys.uniqueId] ?? "N/A")")
        ...
    }

    func genesisValidationError(error: GenesisValidationError) {
        print("Parameter(s) validation error: \(error.errorUserInfo)")
        ...
    }
}
```

## Additional Usage

Set required parameters for transaction type

```swift
let paymentTransactionType = PaymentTransactionType(name: .idebitPayin)
paymentTransactionType.customerAccountId = "customerAccountId"

paymentRequest.transactionTypes = [paymentTransactionType]
```

Set usage or description

```swift
paymentRequest.usage = "Usage"
paymentRequest.paymentDescription = "Description"
```

Set shipping address

```swift
let shippingAddress = PaymentAddress(firstName: "firstName",
                                        lastName: "lastName",
                                        address1: "address1",
                                        address2: "address2",
                                        zipCode: "zipCode",
                                        city: "city",
                                        state: nil,
                                        country: IsoCountryCodes.search(byName: "Country"))

paymentRequest.shippingAddress = shippingAddress
```

Set risk Params

```swift
let riskParams = RiskParams()

riskParams.userId = "userId"
riskParams.sessionId = "sessionId"
riskParams.ssn = "ssn"
riskParams.macAddress = "macAddress"
riskParams.userLevel = "userLevel"
riskParams.email = "email"
riskParams.phone = "phone"
riskParams.remoteIp = "remoteIp"
riskParams.serialNumber = "serialNumber"
riskParams.panTail = "panTail"
riskParams.bin = "bin"
riskParams.firstName = "firstName"
riskParams.lastName = "lastName"
riskParams.country = IsoCountryCodes.search(byName: "Country")
riskParams.pan = "pan"
riskParams.forwardedIp = "forwardedIp"
riskParams.username = "username"
riskParams.password = "password"
riskParams.binName = "binName"
riskParams.binPhone = "binPhone"

paymentRequest.riskParams = riskParams
```

How to use managed recurring in WPF API

```swift
let firstDate = Date().dateByAdding(1, to: .month)
let automaticManagedRecurrring = ManagedRecurringParams.Automatic(period: 22, interval: .days, firstDate: firstDate,
                                                                  timeOfDay: 5, amount: 500, maxCount: 10)
let managedRecurring = ManagedRecurringParams(mode: .automatic(automaticManagedRecurrring))
let transactionType = PaymentTransactionType(name: .initRecurringSale3d)
transactionType.managedRecurring = managedRecurring

paymentRequest.transactionTypes = [transactionType]
```

How to use managed recurring for Indian cards in WPF API (provided data is exemplary, do fill in your specific data per agreement)

```swift
let manualManagedRecurrring = ManagedRecurringParams.Manual(paymentType: .subsequent, amountType: .fixed, frequency: .weekly,                                                                                                                              registrationReferenceNumber: "123434",
                                                            maxAmount: 200, maxCount: 99, validated: true)
let managedRecurring = ManagedRecurringParams(mode: .manual(manualManagedRecurrring))
let transactionType = PaymentTransactionType(name: .initRecurringSale)
transactionType.managedRecurring = managedRecurring

paymentRequest.transactionTypes = [transactionType]
```
 
In order to enforce the 3DSecure v2 authentication protocol, set the 3DSv2 parameters for the following transaction types: Authorize3d, Sale3d, and InitRecurringSale3d.

```swift
// depending on the context, dates can be current, in the past, and in the future 

var threeDSV2Params = ThreeDSV2Params()
threeDSV2Params.controlParams.challengeWindowSize = .fullScreen
threeDSV2Params.purchaseParams = ThreeDSV2Params.PurchaseParams(category: .service)
threeDSV2Params.recurringParams = ThreeDSV2Params.RecurringParams(expirationDate: Date(), frequency: 30)
threeDSV2Params.merchantRiskParams = 
    ThreeDSV2Params.MerchantRiskParams(shippingIndicator: .verifiedAddress,
                                       deliveryTimeframe: .electronic,
                                       reorderItemsIndicator: .reordered,
                                       preOrderPurchaseIndicator: .merchandiseAvailable,
                                       preOrderDate: Date(),
                                       giftCard: true,
                                       giftCardCount: 2)
threeDSV2Params.cardHolderAccountParams =
        ThreeDSV2Params.CardHolderAccountParams(creationDate: Date(),
                                                updateIndicator: .moreThan60Days,
                                                lastChangeDate: Date(),
                                                passwordChangeIndicator: .noChange,
                                                passwordChangeDate: Date(),
                                                shippingAddressUsageIndicator: .currentTransaction,
                                                shippingAddressDateFirstUsed: Date(),
                                                transactionsActivityLast24Hours: 2,
                                                transactionsActivityPreviousYear: 20,
                                                provisionAttemptsLast24Hours: 1,
                                                purchasesCountLast6Months: 5,
                                                suspiciousActivityIndicator: .noSuspiciousObserved,
                                                registrationIndicator: .between30To60Days,
                                                registrationDate: Date())

paymentRequest.threeDSV2Params = threeDSV2Params
```

Check input data

```swift
//This will check all setted data
do {
    try paymentRequest.isValidData()
} catch {
    print(error)
}

//Check address
do {
    try paymentAddress.isValidData()
} catch {
    print(error)
}

//Check transaction type
do {
    try paymentTransactionType.isValidData()
} catch {
    print(error)
}
```

## Required parameters for transaction types

- ApplePay

```swift
let paymentTransactionTypes = [PaymentTransactionType(name: .applePay)]
let paymentSubtype = PaymentSubtype(type: .authorize)

paymentRequest.transactionTypes = paymentTransactionTypes

// paymentSubtype is required for ApplePay transactions
paymentRequest.paymentSubtype = paymentSubtype
```

- Authorize, Authorize3d, Sale, Sale3d

```swift
let authorizeTransactionType = PaymentTransactionType(name: .authorize)
authorizeTransactionType.recurringType = RecurringType(type: .initial)

let saleTransactionType = PaymentTransactionType(name: .sale)
saleTransactionType.recurringType = RecurringType(type: .subsequent)

// recurringType is required for Authorize, Authorize3d, Sale, Sale3d transaction types
paymentRequest.transactionTypes = [authorizeTransactionType, saleTransactionType]
```

- Init Recurring Sale, Init Recurring Sale3d

```swift
let paymentTransactionTypes = [PaymentTransactionType(name: .initRecurringSale), PaymentTransactionType(name: .initRecurringSale3d)]
let recurringCategory = RecurringCategory(category: .subscription)

paymentRequest.transactionTypes = paymentTransactionTypes

// recurringCategory is required for Init Recurring Sale, Init Recurring Sale3d
paymentRequest.recurringCategory = recurringCategory
```

- Reminders

```swift
// Reminders (up to 3) are required when Pay Later property is set to true
paymentRequest.payLater = true
paymentRequest.reminders = [Reminder(channel: .email, after: 30), Reminder(channel: .sms, after: 60)]
```
