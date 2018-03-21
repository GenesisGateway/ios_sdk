//
//  CredentialsTest.swift
//  GenesisSwiftTests
//

import XCTest
@testable import GenesisSwift

class CredentialsTest: XCTestCase {
    let tempUsername = "Username123"
    let tempPassword = "Password123"
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func credentials() -> Credentials {
        return Credentials(withUsername: tempUsername, andPassword: tempPassword)
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

        credentials.username = username
        credentials.password = password
        
        XCTAssertEqual(credentials.encodedCredentialsBase64, self.stringToBase64String("\(credentials.username):\(credentials.password)"))
        XCTAssertEqual(credentials.username, username)
        XCTAssertEqual(credentials.password, password)
    }
    
    func testEmptyCredentials() {
        let credentials = Credentials()
        
        XCTAssertNotEqual(credentials.encodedCredentialsBase64, ":")
        XCTAssertEqual(credentials.encodedCredentialsBase64, self.stringToBase64String(":"))
    }
    
    private func stringToBase64String(_ string: String) -> String {
        let utf8str = string.data(using: String.Encoding.utf8)
        return (utf8str?.base64EncodedString())!
    }
}
