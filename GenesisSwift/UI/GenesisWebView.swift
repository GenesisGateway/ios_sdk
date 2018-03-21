//
//  GenesisWebView.swift
//  GenesisSwift
//

import UIKit
import WebKit

protocol GenesisWebViewDelegate: class {
    func genesisWebViewDidFinishLoading()
    func genesisWebViewDidEndWithSuccess()
    func genesisWebViewDidEndWithCancel()
    func genesisWebViewDidEndWithFailure(errorCode: GenesisError)
}

final class GenesisWebView: NSObject {
    var webView: WKWebView
    let request: PaymentRequest
    var genesisWebViewDelegate: GenesisWebViewDelegate?
    let configuration: Configuration
    
    var uniqueId: String?
    
    init(configuration: Configuration, request: PaymentRequest) {
        self.webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.request = request
        self.configuration = configuration
        super.init()
        webView.navigationDelegate = self
    }
    
    func requestWPF() {
        let requestWPF = WPFRequest(configuration: configuration, parameters: ["request": request])
        requestWPF.execute(successHandler: { (res) in
            let response = res as? WPFResponse
            guard response != nil else {
                let genesisErrorCode = GenesisError(code: GenesisErrorCode.eDataParsing.rawValue,
                                                    technicalMessage: "",
                                                    message: "Data parsing error")
                self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(errorCode: genesisErrorCode)
                return
            }
            
            if let errorCode = response!.errorCode, errorCode.code != nil {
                self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(errorCode: errorCode)
            } else {
                let url = URL(string: response!.redirectUrl)
                self.uniqueId = response!.uniqueId
                DispatchQueue.main.async {
                    if (url != nil) {
                        let redirect = URLRequest(url: url!)
                        self.webView.load(redirect)
                    }
                }
            }
        }) { (error) in
            self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(errorCode: error)
        }
    }
    
    func getErrorFromReconcileAndCallFailure() {
        let reconcileRequest = ReconcileRequest(configuration: configuration, parameters: ["uniqueId" : uniqueId!])
        reconcileRequest.execute(successHandler: { (response) in
            let reconcileResponse = response as! ReconcileResponse
            self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(errorCode: reconcileResponse.errorCode!)
        }) { (error) in
            self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(errorCode: error)
        }
    }
}

// MARK: WKNavigationDelegate
extension GenesisWebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        genesisWebViewDelegate?.genesisWebViewDidFinishLoading()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        let absoluteString = navigationAction.request.url?.absoluteString
        if absoluteString?.lowercased().range(of: self.request.returnSuccessUrl.lowercased()) != nil {
            genesisWebViewDelegate?.genesisWebViewDidEndWithSuccess()
            decisionHandler(.cancel)
        }
        else if absoluteString?.lowercased().range(of: self.request.returnCancelUrl.lowercased()) != nil {
            genesisWebViewDelegate?.genesisWebViewDidEndWithCancel()
            decisionHandler(.cancel)
        }
        else if absoluteString?.lowercased().range(of: self.request.returnFailureUrl.lowercased()) != nil {
            decisionHandler(.cancel)
            getErrorFromReconcileAndCallFailure()
        } else {
            decisionHandler(.allow)
        }
    }
}
