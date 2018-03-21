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
    func genesisValidationError(error: Error)
}

public class Genesis: NSObject {
    ///Your Configuration setup
    public var configuration: Configuration!
    
    ///Your PaymentRequest setup
    public var paymentRequest: PaymentRequest!
    
    ///Protocol for common actions
    public var delegate: GenesisDelegate!
    
    ///If you show with animated = true then back animated will be the same
    public var animatedBack = false
    
    var genesisWebView: GenesisWebView?
    let genesisVC: GenesisViewController = GenesisViewController()
    
    //Remove init/GenesisSwift() for public, force to use with parameters
    override init() {
        super .init()
    }
    
    ///Init with Configuration, PaymentRequest and GenesisDelegate
    //GenesisDelegate is optional
    convenience public init(withConfiguration configuration: Configuration, paymentRequest: PaymentRequest, forDelegate delegate: GenesisDelegate) {
        self.init()
        
        configurate(withConfiguration: configuration, paymentRequest: paymentRequest, forDelegate: delegate)
    }
    
    ///Configurate with Configuration, PaymentRequest and GenesisDelegate
    func configurate(withConfiguration configuration: Configuration, paymentRequest: PaymentRequest, forDelegate delegate: GenesisDelegate) {
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
        self.animatedBack = animated
        
        setupGenesisWebView()
        
        guard (genesisWebView != nil) else {
            return
        }

        if isPush {
            (viewController as! UINavigationController).pushViewController(genesisVC, animated: animated)
        } else {
            viewController.present(genesisVC, animated: animated, completion: completion)
        }
    }
    
    ///Get GenesisViewController and show with custom logic
    public func genesisViewController() -> GenesisViewController? {
        setupGenesisWebView()
        
        guard (genesisWebView != nil) else {
            return nil
        }
        
        return genesisVC
    }
    
    func setupGenesisWebView() {
        guard let gwv = genesisWebViewWithConfiguration() else {
            return
        }
        
        genesisWebView = gwv
    }
    
    ///Back action for navigation and modally view
    public func back(animated: Bool) {
        if let navigationController = genesisVC.navigationController {
            navigationController.popViewController(animated: animated)
        } else {
            genesisVC.dismiss(animated: animated, completion: nil)
        }
    }
    
    func genesisWebViewWithConfiguration() -> GenesisWebView? {
        if !allRequiredPropertiesAreSetted() {
            return nil
        }
        
        do {
            try paymentRequest.isValidData()
        } catch {
            delegate.genesisValidationError(error: error)
            return nil
        }
        
        let genesis = GenesisWebView(configuration: configuration!, request: paymentRequest!)
        genesis.genesisWebViewDelegate = self
        genesis.requestWPF()
        
        return genesis
    }

    func allRequiredPropertiesAreSetted() -> Bool {
        guard (configuration != nil) else {
            return false
        }
        
        guard (paymentRequest != nil) else {
            return false
        }
        
        guard (delegate != nil) else {
            return false
        }
        
        return true
    }
}

//MARK: - GenesisWebViewDelegate
extension Genesis: GenesisWebViewDelegate {
    
    func genesisWebViewDidFinishLoading() {
        genesisVC.indicator.stopAnimating()
        genesisVC.addView((genesisWebView?.webView)!)
        
        self.delegate?.genesisDidFinishLoading()
    }
    
    func genesisWebViewDidEndWithSuccess() {
        self.back(animated: animatedBack)
        
        self.delegate?.genesisDidEndWithSuccess()
    }
    
    func genesisWebViewDidEndWithCancel() {
        self.back(animated: animatedBack)
        
        self.delegate?.genesisDidEndWithCancel()
    }
    
    func genesisWebViewDidEndWithFailure(errorCode: GenesisError) {
        self.back(animated: animatedBack)
        
        self.delegate?.genesisDidEndWithFailure(errorCode: errorCode)
    }
}
