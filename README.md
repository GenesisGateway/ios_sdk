# Genesis iOS SDK
>

[![Build Status](https://img.shields.io/travis/GenesisGateway/ios_sdk.svg?style=flat)](https://travis-ci.org/GenesisGateway/ios_sdk)

## Table of Contents
- [Requirements](#requirements)
- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Additional Usage](#additional-usage)

## Requirements

- iOS 9.0+
- Xcode 9.2

## Installation

GenesisSwift requires Swift 4, so make sure you have [Xcode 9](https://developer.apple.com/xcode/downloads/).

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

    func genesisDidFinishLoading() {
        ...
    }

    func genesisDidEndWithSuccess() {
        ...
    }

    func genesisDidEndWithFailure(errorCode: GenesisErrorCode) {
        ...
    }

    func genesisDidEndWithCancel() {
        ...
    }
    
    func genesisValidationError(error: GenesisValidationError) {
        print(error.errorUserInfo)
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
