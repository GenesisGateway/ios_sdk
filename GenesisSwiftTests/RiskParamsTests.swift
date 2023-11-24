//
//  RiskParamsTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import GenesisSwift

final class RiskParamsTests: XCTestCase {
    private var sut: RiskParams!
}

extension RiskParamsTests {

    func testFullParams() {
        sut = RiskParams(userId: "fixed.userId", sessionId: "fixed.sessionId", ssn: nil, macAddress: nil, userLevel: nil,
                         email: nil, phone: nil, remoteIp: nil, serialNumber: nil, panTail: nil, bin: nil,
                         firstName: nil, lastName: nil, country: nil, pan: nil, forwardedIp: nil,
                         username: nil, password: nil, binName: nil, binPhone: nil)
        XCTAssertEqual(sut.userId, "fixed.userId")
        XCTAssertEqual(sut.sessionId, "fixed.sessionId")
    }

    func testOnlyUser() {
        sut = RiskParams(userId: "fixed.userId", sessionId: nil, ssn: nil, macAddress: nil, userLevel: nil,
                         email: nil, phone: nil, remoteIp: nil, serialNumber: nil, panTail: nil, bin: nil,
                         firstName: nil, lastName: nil, country: nil, pan: nil, forwardedIp: nil,
                         username: nil, password: nil, binName: nil, binPhone: nil)
        XCTAssertEqual(sut.userId, "fixed.userId")
        XCTAssertNil(sut.sessionId)
    }

    func testOnlySession() {
        sut = RiskParams(userId: nil, sessionId: "fixed.sessionId", ssn: nil, macAddress: nil, userLevel: nil,
                         email: nil, phone: nil, remoteIp: nil, serialNumber: nil, panTail: nil, bin: nil,
                         firstName: nil, lastName: nil, country: nil, pan: nil, forwardedIp: nil,
                         username: nil, password: nil, binName: nil, binPhone: nil)
        XCTAssertNil(sut.userId)
        XCTAssertEqual(sut.sessionId, "fixed.sessionId")
    }

    func testDescription() {
        let riskParams = RiskParams()
        riskParams.userId = "userId"
        riskParams.sessionId = "sessionId"
        riskParams.ssn = "ssn"
        riskParams.macAddress = "macAddress"
        riskParams.userLevel = "userLevel"
        riskParams.email = "email"
        riskParams.phone = nil
        riskParams.remoteIp = "remoteIp"
        riskParams.serialNumber = "serialNumber"
        riskParams.panTail = "panTail"
        riskParams.bin = "bin"
        riskParams.firstName = "firstName"
        riskParams.lastName = "lastName"
        riskParams.country = IsoCountryCodes.search(byName: "United States")
        riskParams.pan = "pan"
        riskParams.forwardedIp = "forwardedIp"
        riskParams.username = "username"
        riskParams.password = "password"
        riskParams.binName = "binName"
        riskParams.binPhone = "binPhone"

        let output =
            """
            <user_id>userId</user_id><session_id>sessionId</session_id><ssn>ssn</ssn><mac_address>macAddress</mac_address>\
            <user_level>userLevel</user_level><email>email</email><remote_ip>remoteIp</remote_ip>\
            <serial_number>serialNumber</serial_number><pan_tail>panTail</pan_tail><bin>bin</bin>\
            <first_name>firstName</first_name><last_name>lastName</last_name><country>United States</country><pan>pan</pan>\
            <forwarded_ip>forwardedIp</forwarded_ip><username>username</username><password>password</password>\
            <bin_name>binName</bin_name><bin_phone>binPhone</bin_phone>
            """
        XCTAssertEqual(riskParams.description(), output)
    }
}
