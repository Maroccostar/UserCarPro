//
//  File.swift
//  
//
//  Created by user on 10.04.2022.
//
@testable import App
import XCTVapor
import Foundation
import Fluent

final class TestUserController: XCTestCase {
    
    func testCreateUser() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        let userRequest = CreateUserRequest(name: "Vasil", username: "Homenko", patronymic: "Vasilovich")
        
        try app.test(.POST, "/v1/users",beforeRequest: { req in
            try req.content.encode(userRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let contentType = try XCTUnwrap(res.headers.contentType)
            XCTAssertEqual(contentType, .json)
            XCTAssertNotNil(res.content)
            XCTAssertContent(UserResponse.self, res) { (content) in
                XCTAssertEqual(userRequest.name, content.name)
                XCTAssertEqual(userRequest.username, content.username)
                XCTAssertEqual(userRequest.patronymic, content.patronymic)
            }
        })
        try app.autoRevert().wait()
    }
    
    
    func testGetUser() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        let userRequest = CreateUserRequest(name: "Vasil", username: "Homenko", patronymic: "Vasilovich")
        
        try app.test(.POST, "/v1/users",beforeRequest: { req in
            try req.content.encode(userRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let contentType = try XCTUnwrap(res.headers.contentType)
            XCTAssertEqual(contentType, .json)
            XCTAssertNotNil(res.content)
            XCTAssertContent(UserResponse.self, res) { (content) in
                XCTAssertEqual(userRequest.name, content.name)
                XCTAssertEqual(userRequest.username, content.username)
                XCTAssertEqual(userRequest.patronymic, content.patronymic)
            }
        })
       // try app.test(.GET, <#T##path: String##String#>)
    }
}
