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
        let app = Application(.testing)// service setup
        defer { app.shutdown() }// service setup
        try configure(app)// service setup
        let userRequest = CreateUserRequest(name: "Vasil", username: "Homenko", patronymic: "Vasilovich")
        var userID: UUID? // create user
        try app.test(.POST, "/v1/users",beforeRequest: { req in// req test
            try req.content.encode(userRequest) // code data
        }, afterResponse: { res in// response comparison
            XCTAssertEqual(res.status, .ok)
            let contentType = try XCTUnwrap(res.headers.contentType) //get content type
            XCTAssertEqual(contentType, .json)// comparison content and json
            XCTAssertNotNil(res.content)// content != nil
            XCTAssertContent(UserResponse.self, res) { (content) in// decode
                userID = content.id //
                XCTAssertEqual(userRequest.name, content.name)// content value comparison
                XCTAssertEqual(userRequest.username, content.username)
                XCTAssertEqual(userRequest.patronymic, content.patronymic)
            }
        })
        try app.test(.GET, "/v1/users/\(userID!)",afterResponse: { (res) in
            XCTAssertEqual(res.status, .ok)
            let contentType = try XCTUnwrap(res.headers.contentType)
            XCTAssertEqual(contentType, .json)
            XCTAssertNotNil(res.content)// != nil
            XCTAssertContent(UserResponse.self, res) { (content) in// decode
                XCTAssertEqual(userRequest.name, content.name)// content comparison
                XCTAssertEqual(userRequest.username, content.username)
                XCTAssertEqual(userRequest.patronymic, content.patronymic)
            }
        })
        try app.autoRevert().wait()
    }
    
    
    
    
    func testDeleteUser() throws {
        let app = Application(.testing)// service setup
        defer { app.shutdown() }// service setup
        try configure(app)// service setup
        let userRequest = CreateUserRequest(name: "Vasil", username: "Homenko", patronymic: "Vasilovich")
        var userID: UUID? // create user
        try app.test(.POST, "/v1/users",beforeRequest: { req in// req test
            try req.content.encode(userRequest) // code data
        }, afterResponse: { res in// response comparison
            XCTAssertEqual(res.status, .ok)
            let contentType = try XCTUnwrap(res.headers.contentType) //get content type
            XCTAssertEqual(contentType, .json)// comparison content and json
            XCTAssertNotNil(res.content)// content != nil
            XCTAssertContent(UserResponse.self, res) { (content) in// decode
                userID = content.id //
                XCTAssertEqual(userRequest.name, content.name)// content value comparison
                XCTAssertEqual(userRequest.username, content.username)
                XCTAssertEqual(userRequest.patronymic, content.patronymic)
            }
        })
        try app.test(.DELETE, "/v1/users/\(userID!)/force/",afterResponse: { (res) in
            XCTAssertEqual(res.status, .noContent) //возв только notFound не  noContent
                
        })
        try app.autoRevert().wait()
    }
    
}
