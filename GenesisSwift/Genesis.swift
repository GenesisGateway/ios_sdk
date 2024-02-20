//
//  GenesisSwift.swift
//  GenesisSwift
//

import UIKit

public enum GenesisInfoKeys {
    public static let uniqueId = "uniqueId" // String
    public static let status = "status" // String
    public static let transactionId = "transactionId" // String
    public static let timestamp = "timestamp" // Date
    public static let amount = "amount" // Double
    public static let currency = "currency" // String
    public static let redirectUrl = "redirectUrl" // String
}

public protocol GenesisDelegate: AnyObject {
    func genesisDidFinishLoading(userInfo: [AnyHashable: Any])
    func genesisDidEndWithSuccess(userInfo: [AnyHashable: Any])
    func genesisDidEndWithCancel(userInfo: [AnyHashable: Any])
    func genesisDidEndWithFailure(userInfo: [AnyHashable: Any], errorCode: GenesisError)
    func genesisValidationError(error: GenesisValidationError)
}

public class Genesis: NSObject {
    /// Your Configuration setup
    public private(set) var configuration: Configuration

    /// Your PaymentRequest setup
    public private(set) var paymentRequest: PaymentRequest

    /// Protocol for common actions
    public private(set) var delegate: GenesisDelegate

    /// If you show with animated = true then back animated will be the same
    public var animatedBack = false

    private(set) var genesisWebView: GenesisWebView?
    private(set) lazy var genesisVC = GenesisViewController()

    // Init with Configuration, PaymentRequest and GenesisDelegate
    public init(withConfiguration configuration: Configuration, paymentRequest: PaymentRequest, forDelegate delegate: GenesisDelegate) {
        self.configuration = configuration
        self.paymentRequest = paymentRequest
        self.delegate = delegate
    }

    /// Present modal view to ViewController
    public func present(toViewController viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        showView(toViewController: viewController, animated: animated, forPush: false, completion: completion)
    }

    /// Push view to NavigationController
    public func push(toNavigationController navigationController: UINavigationController, animated: Bool) {
        showView(toViewController: navigationController, animated: animated, forPush: true, completion: nil)
    }

    func showView(toViewController viewController: UIViewController, animated: Bool, forPush isPush: Bool, completion: (() -> Void)? = nil) {
        animatedBack = animated

        setupGenesisWebView()
        guard genesisWebView != nil else { return }

        if isPush, let navigationController = viewController as? UINavigationController {
            navigationController.pushViewController(genesisVC, animated: animated)
        } else {
            viewController.present(genesisVC, animated: animated, completion: completion)
        }
    }

    /// Get GenesisViewController and show with custom logic
    public func genesisViewController() -> GenesisViewController? {
        setupGenesisWebView()
        guard genesisWebView != nil else { return nil }

        return genesisVC
    }

    func setupGenesisWebView() {
        if let gwv = genesisWebViewWithConfiguration() {
            genesisWebView = gwv
        }
    }

    /// Back action for navigation and modally view
    public func back(animated: Bool) {
        if let navigationController = genesisVC.navigationController {
            navigationController.popViewController(animated: animated)
        } else {
            genesisVC.dismiss(animated: animated)
        }
    }

    func genesisWebViewWithConfiguration() -> GenesisWebView? {
        do {
            try paymentRequest.isValidData()
        } catch {
            if let error = error as? GenesisValidationError {
                delegate.genesisValidationError(error: error)
            }
            return nil
        }

        let genesis = GenesisWebView(configuration: configuration, request: paymentRequest)
        genesis.genesisWebViewDelegate = self
        genesis.requestWPF()

        return genesis
    }
}

// MARK: - GenesisWebViewDelegate

extension Genesis: GenesisWebViewDelegate {

    func genesisWebViewDidFinishLoading(_ userInfo: [AnyHashable: Any]) {
        genesisVC.indicator.stopAnimating()
        genesisVC.addView((genesisWebView?.webView)!)

        delegate.genesisDidFinishLoading(userInfo: userInfo)
    }

    func genesisWebViewDidEndWithSuccess(_ userInfo: [AnyHashable: Any]) {
        back(animated: animatedBack)

        delegate.genesisDidEndWithSuccess(userInfo: userInfo)
    }

    func genesisWebViewDidEndWithCancel(_ userInfo: [AnyHashable: Any]) {
        back(animated: animatedBack)

        delegate.genesisDidEndWithCancel(userInfo: userInfo)
    }

    func genesisWebViewDidEndWithFailure(_ userInfo: [AnyHashable: Any], errorCode: GenesisError) {
        back(animated: animatedBack)

        delegate.genesisDidEndWithFailure(userInfo: userInfo, errorCode: errorCode)
    }
}
