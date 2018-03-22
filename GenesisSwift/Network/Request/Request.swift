//
//  Request.swift
//  GenesisSwift
//

import Foundation

enum Path: String {
    case wpf = "/wpf"
    case reconcile = "/wpf/reconcile"
}

protocol RequestProtocol {
    func path() -> String
    func httpBody() -> Data?
    func processingResponseString(string: String) -> Any?
}

typealias SuccessResponse = (Any!) -> Void
typealias FailureBlock = (GenesisError!) -> Void

class Request: NSObject {
    var request: URLRequest?
    
    var successHandler: SuccessResponse?
    var failureHandler: FailureBlock?
    var responseString: String?
    var parameters: [String: Any]?
 
    init(configuration: Configuration, parameters: [String: Any]?) {
        super.init()
        
        self.request = self.urlRequest(forConfiguration: configuration)
        self.parameters = parameters
    }
    
    func urlRequest(forConfiguration configuration: Configuration) -> URLRequest {
        let selfInstance = self.requestProtocolSelfInstance()

        var request = URLRequest(url: URL(string: configuration.urlString + selfInstance.path())!)
        request.setValue("Basic \(configuration.credentials.encodedCredentialsBase64)", forHTTPHeaderField: "Authorization")
        request.setValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        return request
    }
    
    func requestProtocolSelfInstance() -> RequestProtocol {
        let selfInstance = self as? RequestProtocol
        if selfInstance == nil {
            assert(false, "need extension of RequestProtocol for the child")
        }
        
        return selfInstance!
    }
    
    func callSuccessWithResponseString(responseString: String) {
        DispatchQueue.main.async {
            let selfInstance = self.requestProtocolSelfInstance()
            self.successHandler?(selfInstance.processingResponseString(string: responseString))
        }
    }
    
    func execute(successHandler: SuccessResponse?, failureHandler: FailureBlock?) {
        let selfInstance = self.requestProtocolSelfInstance()
        
        request!.httpBody = selfInstance.httpBody()
        self.successHandler = successHandler
        self.failureHandler = failureHandler
        
        let dataTask = URLSession.shared.dataTask(with: request!, completionHandler: { (data, response, error) in
            if error != nil {
                failureHandler?(error as! GenesisError)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if statusCode == 200 {
                self.responseString = String(data: data!, encoding: .utf8)
                guard (self.responseString != nil) else {
                    let genesisError = GenesisError(code: GenesisErrorCode.eDataParsing.rawValue,
                                                        technicalMessage: "",
                                                        message: "Data parsing error")
                    failureHandler?(genesisError)
                    return
                }
                
                self.callSuccessWithResponseString(responseString: self.responseString!)
            } else {
                var genesisError: GenesisError
                switch statusCode {
                case 401:
                    genesisError = GenesisError(code: GenesisErrorCode.e401.rawValue,
                                                        technicalMessage: "Authentication Error",
                                                        message: "")
                    break
                case 404:
                    genesisError = GenesisError(code: GenesisErrorCode.e404.rawValue,
                                                        technicalMessage: "NotFound Error",
                                                        message: "")
                    break
                case 426:
                    genesisError = GenesisError(code: GenesisErrorCode.e426.rawValue,
                                                        technicalMessage: "Upgrade Required Error",
                                                        message: "")
                    break
                case 500:
                    genesisError = GenesisError(code: GenesisErrorCode.e500.rawValue,
                                                        technicalMessage: "Server Error",
                                                        message: "")
                    break
                case 503:
                    genesisError = GenesisError(code: GenesisErrorCode.e503.rawValue,
                                                        technicalMessage: "Down for Maintenance Error",
                                                        message: "")
                default:
                    genesisError = GenesisError(code: String(statusCode),
                                                technicalMessage: "Error",
                                                message: "")
                    break
                }
                
                failureHandler?(genesisError)
            }
        })
        
        dataTask.resume()
    }
}
