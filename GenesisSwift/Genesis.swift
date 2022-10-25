//
//  GenesisSwift.swift
//  GenesisSwift
//

import UIKit

public protocol GenesisDelegate {
    func genesisDidFinishLoading()
    func genesisDidEndWithSuccess()
    func genesisDidEndWithCancel()
    func genesisDidEndWithFailure(errorCode: GenesisError)
    func genesisValidationError(error: GenesisValidationError)
}

public class Genesis: NSObject {
    ///Your Configuration setup
    public private(set) var configuration: Configuration

    ///Your PaymentRequest setup
    public private(set) var paymentRequest: PaymentRequest

    ///Protocol for common actions
    public private(set) var delegate: GenesisDelegate

    ///If you show with animated = true then back animated will be the same
    public var animatedBack = false

    private(set) var genesisWebView: GenesisWebView?
    private(set) lazy var genesisVC = GenesisViewController()

    ///Init with Configuration, PaymentRequest and GenesisDelegate
    //GenesisDelegate is optional
    public init(withConfiguration configuration: Configuration, paymentRequest: PaymentRequest, forDelegate delegate: GenesisDelegate) {
        self.configuration = configuration
        self.paymentRequest = paymentRequest
        self.delegate = delegate
    }

    ///Present modal view to ViewController
    public func present(toViewController viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        showView(toViewController: viewController, animated: animated, forPush: false, completion: completion)
    }

    ///Push view to NavigationController
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

    ///Get GenesisViewController and show with custom logic
    public func genesisViewController() -> GenesisViewController? {
        setupGenesisWebView()
        guard genesisWebView != nil else { return nil }

        return genesisVC
    }

    func setupGenesisWebView() {
        guard let gwv = genesisWebViewWithConfiguration() else { return }
        genesisWebView = gwv
    }

    ///Back action for navigation and modally view
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
            delegate.genesisValidationError(error: error as! GenesisValidationError)
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

    func genesisWebViewDidFinishLoading() {
        genesisVC.indicator.stopAnimating()
        genesisVC.addView((genesisWebView?.webView)!)

        delegate.genesisDidFinishLoading()
    }

    func genesisWebViewDidEndWithSuccess() {
        back(animated: animatedBack)

        delegate.genesisDidEndWithSuccess()
    }

    func genesisWebViewDidEndWithCancel() {
        back(animated: animatedBack)

        delegate.genesisDidEndWithCancel()
    }

    func genesisWebViewDidEndWithFailure(errorCode: GenesisError) {
        back(animated: animatedBack)

        delegate.genesisDidEndWithFailure(errorCode: errorCode)
    }
}
