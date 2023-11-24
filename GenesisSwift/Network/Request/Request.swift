//
//  Request.swift
//  GenesisSwift
//

import Foundation

enum Path: String {
    case wpf = "/wpf"
    case reconcile = "/wpf/reconcile"
}

// MARK: - RequestProtocol

protocol RequestProtocol {
    var path: String { get }
    var httpBody: Data? { get }

    func processResponseString(_ string: String) -> Any?
}

// MARK: - Request

class Request: RequestProtocol {

    typealias SuccessHandler = (Any) -> Void
    typealias FailureHandler = (GenesisError) -> Void

    private let configuration: Configuration

    private(set) var parameters: [String: Any]?
    private(set) lazy var request: URLRequest = {
        urlRequest(forConfiguration: configuration)
    }()

    init(configuration: Configuration, parameters: [String: Any]?) {
        self.configuration = configuration
        self.parameters = parameters
    }

    var path: String {
        assertionFailure("Descendant type must provide path")
        return ""
    }

    var httpBody: Data? {
        assertionFailure("Descendant type must provide httpBody")
        return nil
    }

    func processResponseString(_ string: String) -> Any? {
        assertionFailure("Descendant type must process response")
        return nil
    }
}

extension Request {

    func execute(successHandler: @escaping SuccessHandler, failureHandler: @escaping FailureHandler) {

        request.httpBody = httpBody
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                if let error = error as? GenesisError {
                    failureHandler(error)
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                failureHandler(GenesisError(message: "Invalid response"))
                return
            }

            let statusCode = httpResponse.statusCode
            if statusCode == 200, let data = data {
                guard let responseString = String(data: data, encoding: .utf8) else {
                    let genesisError = GenesisError(code: GenesisErrorCode.eDataParsing.rawValue,
                                                    technicalMessage: "",
                                                    message: "Data parsing error")
                    failureHandler(genesisError)
                    return
                }

                self.handleSuccess(withResponseString: responseString, with: successHandler)
            } else {
                self.handleFailure(forStatusCode: statusCode, with: failureHandler)
            }
        }

        dataTask.resume()
    }
}

private extension Request {

    func urlRequest(forConfiguration configuration: Configuration) -> URLRequest {
        var request = URLRequest(url: URL(string: configuration.urlString + path)!)
        request.setValue("Basic \(configuration.credentials.encodedCredentialsBase64)", forHTTPHeaderField: "Authorization")
        request.setValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        return request
    }

    func handleSuccess(withResponseString responseString: String, with successHandler: @escaping SuccessHandler) {
        if let response = processResponseString(responseString) {
            DispatchQueue.main.async {
                successHandler(response)
            }
        }
    }

    func handleFailure(forStatusCode statusCode: Int, with failureHandler: @escaping FailureHandler) {
        var genesisError: GenesisError
        switch statusCode {
        case 401:
            genesisError = GenesisError(code: GenesisErrorCode.e401.rawValue,
                                        technicalMessage: "Authentication Error",
                                        message: "")
        case 404:
            genesisError = GenesisError(code: GenesisErrorCode.e404.rawValue,
                                        technicalMessage: "NotFound Error",
                                        message: "")
        case 426:
            genesisError = GenesisError(code: GenesisErrorCode.e426.rawValue,
                                        technicalMessage: "Upgrade Required Error",
                                        message: "")
        case 500:
            genesisError = GenesisError(code: GenesisErrorCode.e500.rawValue,
                                        technicalMessage: "Server Error",
                                        message: "")
        case 503:
            genesisError = GenesisError(code: GenesisErrorCode.e503.rawValue,
                                        technicalMessage: "Down for Maintenance Error",
                                        message: "")
        default:
            genesisError = GenesisError(code: String(statusCode),
                                        technicalMessage: "Error",
                                        message: "")
        }

        DispatchQueue.main.async {
            failureHandler(genesisError)
        }
    }
}
