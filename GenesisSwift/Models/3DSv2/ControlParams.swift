//
//  ControlParams.swift
//  GenesisSwift
//
//  Created by Ivaylo Hadzhiev on 14.10.22.
//  Copyright © 2022 eMerchantPay. All rights reserved.
//

import Foundation

public extension ThreeDSV2Params {

    struct ControlParams {

        public enum ChallengeIndicatorValues: String, CaseIterable {
            case noPreference = "no_preference"
            case noChallengeRequested = "no_challenge_requested"
            case preference
            case mandate
        }

        public enum ChallengeWindowSizeValues: String, CaseIterable {
            case fullScreen = "full_screen"
            case dimensions250x400 = "250x400"
            case dimensions390x400 = "390x400"
            case dimensions500x600 = "500x600"
            case dimensions600x400 = "600x400"
        }

        enum DeviceTypeValues: String, CaseIterable {
            case application
            case browser
        }

        public var challengeIndicator: ChallengeIndicatorValues = .noPreference
        public var challengeWindowSize: ChallengeWindowSizeValues?

        private var deviceType: DeviceTypeValues = .application
    }
}

// MARK: - GenesisDescriptionProtocol

extension ThreeDSV2Params.ControlParams: GenesisDescriptionProtocol, XMLConvertable {

    func description() -> String {
        var xmlString = ""
        xmlString += toXML(name: "device_type", value: deviceType.rawValue)
        xmlString += toXML(name: "challenge_indicator", value: challengeIndicator.rawValue)
        xmlString += toXML(name: "challenge_window_size", value: challengeWindowSize?.rawValue)
        return xmlString
    }
}
