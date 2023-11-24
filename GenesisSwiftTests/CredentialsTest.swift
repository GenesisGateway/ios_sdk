//
//  CredentialsTest.swift
//  GenesisSwiftTests
//

import XCTest
@testable import GenesisSwift

final class CredentialsTest: XCTestCase {
    let tempUsername = "Username123"
    let tempPassword = "Password123"
}

extension CredentialsTest {

    func credentials() -> Credentials {
        Credentials(withUsername: tempUsername, andPassword: tempPassword)
    }

    func testCredentials() {
        let credentials = self.credentials()

        XCTAssertEqual(credentials.encodedCredentialsBase64, self.stringToBase64String("\(credentials.username):\(credentials.password)"))
        XCTAssertEqual(credentials.username, tempUsername)
        XCTAssertEqual(credentials.password, tempPassword)
    }

    func testChangeCredentialsValues() {
        let credentials = self.credentials()

        let username = "username"
        let password = "password"

        credentials.setUsername(username)
        credentials.setPassword(password)

        XCTAssertEqual(credentials.encodedCredentialsBase64, stringToBase64String("\(credentials.username):\(credentials.password)"))
        XCTAssertEqual(credentials.username, username)
        XCTAssertEqual(credentials.password, password)
    }

    func testEmptyCredentials() {
        let credentials = Credentials()

        XCTAssertNotEqual(credentials.encodedCredentialsBase64, ":")
        XCTAssertEqual(credentials.encodedCredentialsBase64, self.stringToBase64String(":"))
    }
}

private extension CredentialsTest {

    func stringToBase64String(_ string: String) -> String {
        Data(string.utf8).base64EncodedString()
    }
}
