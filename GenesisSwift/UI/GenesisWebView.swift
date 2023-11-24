//
//  GenesisWebView.swift
//  GenesisSwift
//

import UIKit
import WebKit

protocol GenesisWebViewDelegate: AnyObject {
    func genesisWebViewDidFinishLoading()
    func genesisWebViewDidEndWithSuccess()
    func genesisWebViewDidEndWithCancel()
    func genesisWebViewDidEndWithFailure(errorCode: GenesisError)
}

final class GenesisWebView: NSObject {

    private let request: PaymentRequest
    private let configuration: Configuration
    private var uniqueId: String?

    let webView: WKWebView

    var genesisWebViewDelegate: GenesisWebViewDelegate?

    init(configuration: Configuration, request: PaymentRequest) {
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.request = request
        self.configuration = configuration
        super.init()
        webView.navigationDelegate = self
    }

    deinit {
        genesisWebViewDelegate = nil
    }

    func requestWPF() {
        let requestWPF = WPFRequest(configuration: configuration, parameters: ["request": request])
        requestWPF.execute(successHandler: { [weak self] response in
            guard let self = self else { return }

            guard let response = response as? WPFResponse else {
                let genesisErrorCode = GenesisError(code: GenesisErrorCode.eDataParsing.rawValue,
                                                    technicalMessage: "",
                                                    message: "Data parsing error")
                self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(errorCode: genesisErrorCode)
                return
            }

            if let errorCode = response.errorCode, errorCode.code != nil {
                self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(errorCode: errorCode)
            } else {
                uniqueId = response.uniqueId

                if let url = URL(string: response.redirectUrl) {
                    DispatchQueue.main.async { [weak self] in
                        self?.webView.load(URLRequest(url: url))
                    }
                }
            }
        }, failureHandler: { [weak self] error in
            self?.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(errorCode: error)
        })
    }

    func getErrorFromReconcileAndCallFailure() {
        let reconcileRequest = ReconcileRequest(configuration: configuration, parameters: ["uniqueId": uniqueId!])
        reconcileRequest.execute(successHandler: { [weak self] response in
            if let response = response as? ReconcileResponse, let errorCode = response.errorCode {
                self?.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(errorCode: errorCode)
            } else {
                self?.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(errorCode: GenesisError(message: "error"))
            }
        }, failureHandler: { [weak self] error in
            self?.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(errorCode: error)
        })
    }
}

// MARK: WKNavigationDelegate
extension GenesisWebView: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        genesisWebViewDelegate?.genesisWebViewDidFinishLoading()
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let absoluteString = navigationAction.request.url?.absoluteString.lowercased() {
            if absoluteString.contains(request.returnSuccessUrl.lowercased()) {
                genesisWebViewDelegate?.genesisWebViewDidEndWithSuccess()
                decisionHandler(.cancel)
            } else if absoluteString.contains(request.returnCancelUrl.lowercased()) {
                genesisWebViewDelegate?.genesisWebViewDidEndWithCancel()
                decisionHandler(.cancel)
            } else if absoluteString.contains(request.returnFailureUrl.lowercased()) {
                decisionHandler(.cancel)
                getErrorFromReconcileAndCallFailure()
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}
