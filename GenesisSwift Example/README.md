# Genesis Example App

## Requirements

- iOS 12+
- Xcode 14+

## Initial project setup

1. Clone repository
```
git clone https://github.com/GenesisGateway/ios_sdk.git
```
2. Open the example project with Xcode at
```
/GenesisSwift Example/GenesisSwift Example.xcodeproj
```
3. Select the iOS Example target
4. Build and run

## Work with the Example app

1. Fill in your testing credentials in the fields Username and Password. If you don’t have testing credentials, please contact tech-support@emerchantpay.com
2. Choose your desired configuration
3. Select the type of transaction to test with
4. On the next screen, fill in all the necessary parameters (all parameter value changes are preserved between payments and app executions)
5. Select PAY at the bottom of the screen
6. If a parameter value is not within its valid range, you will be presented with an alert describing what needs to change
7. If all parameter values are valid, then a request to Genesis is made.
8. You can continue to test the transaction within the Genesis WPF interface.
