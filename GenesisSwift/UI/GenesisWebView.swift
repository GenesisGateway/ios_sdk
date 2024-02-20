//
//  GenesisWebView.swift
//  GenesisSwift
//

import UIKit
import WebKit

protocol GenesisWebViewDelegate: AnyObject {
    func genesisWebViewDidFinishLoading(_ userInfo: [AnyHashable: Any])
    func genesisWebViewDidEndWithSuccess(_ userInfo: [AnyHashable: Any])
    func genesisWebViewDidEndWithCancel(_ userInfo: [AnyHashable: Any])
    func genesisWebViewDidEndWithFailure(_ userInfo: [AnyHashable: Any], errorCode: GenesisError)
}

final class GenesisWebView: NSObject {

    private let request: PaymentRequest
    private let configuration: Configuration
    private var response: Response?

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
                self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(self.userInfo, errorCode: genesisErrorCode)
                return
            }

            self.response = response

            if let errorCode = response.errorCode, errorCode.code != nil {
                self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(self.userInfo, errorCode: errorCode)
            } else {
                if let url = URL(string: response.redirectUrl) {
                    DispatchQueue.main.async { [weak self] in
                        self?.webView.load(URLRequest(url: url))
                    }
                } else {
                    self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(self.userInfo,
                                                                                 errorCode: GenesisError(message: "Invalid URL"))
                }
            }
        }, failureHandler: { [weak self] error in
            guard let self else { return }
            self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(self.userInfo, errorCode: error)
        })
    }
}

private extension GenesisWebView {

    func getErrorFromReconcileAndCallFailure() {
        guard let uniqueId = response?.uniqueId else {
            self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(userInfo, errorCode: GenesisError(message: "error"))
            return
        }

        let reconcileRequest = ReconcileRequest(configuration: configuration, parameters: ["uniqueId": uniqueId])
        reconcileRequest.execute(successHandler: { [weak self] response in
            guard let self else { return }
            let userInfo = self.userInfo
            if let response = response as? ReconcileResponse, let errorCode = response.errorCode {
                self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(userInfo, errorCode: errorCode)
            } else {
                self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(userInfo, errorCode: GenesisError(message: "error"))
            }
        }, failureHandler: { [weak self] error in
            guard let self else { return }
            self.genesisWebViewDelegate?.genesisWebViewDidEndWithFailure(self.userInfo, errorCode: error)
        })
    }

    var userInfo: [AnyHashable: Any] {
        var info: [AnyHashable: Any] = [:]

        guard let response else { return info }

        if !response.uniqueId.isEmpty {
            info[GenesisInfoKeys.uniqueId] = response.uniqueId
        }
        info[GenesisInfoKeys.status] = response.status.rawValue

        if let response = response as? WPFResponse {
            if !response.transactionId.isEmpty {
                info[GenesisInfoKeys.transactionId] = response.transactionId
            }
            if let timestamp = response.timestamp {
                info[GenesisInfoKeys.timestamp] = timestamp
            }
            info[GenesisInfoKeys.amount] = response.amount
            if !response.currency.isEmpty {
                info[GenesisInfoKeys.currency] = response.currency
            }
            if !response.redirectUrl.isEmpty {
                info[GenesisInfoKeys.redirectUrl] = response.redirectUrl
            }
        }

        return info
    }
}

// MARK: WKNavigationDelegate
extension GenesisWebView: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        genesisWebViewDelegate?.genesisWebViewDidFinishLoading(userInfo)
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let absoluteString = navigationAction.request.url?.absoluteString.lowercased() {
            if absoluteString.contains(request.returnSuccessUrl.lowercased()) {
                genesisWebViewDelegate?.genesisWebViewDidEndWithSuccess(userInfo)
                decisionHandler(.cancel)
            } else if absoluteString.contains(request.returnCancelUrl.lowercased()) {
                genesisWebViewDelegate?.genesisWebViewDidEndWithCancel(userInfo)
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
