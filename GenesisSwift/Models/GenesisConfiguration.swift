//
//  GenesisConfiguration.swift
//  GenesisSwift
//

import UIKit

public enum ConfigEnvironment: String {
    case production = ""
    case staging = "staging."
}

public enum ConfigEndpoint: String {
    case emerchantpay = "emerchantpay.net"
    case ecomprocessing = "e-comprocessing.net"
}

public enum ConfigLanguage: String {
    case en     // English (this is the default)
    case it     // Italian
    case es     // Spanish
    case fr     // French
    case de     // German
    case ja     // Japanese
    case zh     // Mandarin Chinese
    case ar     // Arabic
    case pt     // Portuguese
    case tr     // Turkish
    case ru     // Russian
    case hi     // Hindu
    case bg     // Bulgarian
}

public struct Configuration {
    let credentials: Credentials
    let language: ConfigLanguage
    let environment: ConfigEnvironment
    let endpoint: ConfigEndpoint
    
/// Default initialization
///
/// - Parameters:
///     - credentials: YOUR_USERNAME:YOUR_PASSWORD
///     - language: ConfigLanguage enum
///     - environment: ConfigEnvironment enum
///     - endpoint: ConfigEndpoint enum
///
    public init(credentials: Credentials,
                language: ConfigLanguage,
                environment: ConfigEnvironment,
                endpoint: ConfigEndpoint) {
        
        self.credentials = credentials
        self.language = language
        self.environment = environment
        self.endpoint = endpoint
    }
    
    var urlString: String {
        return "https://" + environment.rawValue + "wpf." + endpoint.rawValue + "/" + language.rawValue
    }
    
    var serverURL: URL {
        guard let serverUrl = URL(string: urlString) else {
            return URL(string: "")!
        }
        return serverUrl
    }
}
