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
    
    
    func testUpdateUser() throws {
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
        let userRequestU = UpdateUserRequest(name: "U", username: "U", patronymic: "U")
        try app.test(.PATCH, "/v1/users/\(userID!)",beforeRequest: { req in// req test
            try req.content.encode(userRequestU) // code data
        }, afterResponse: { res in// response comparison
            XCTAssertEqual(res.status, .ok)
            let contentType = try XCTUnwrap(res.headers.contentType) //get content type
            XCTAssertEqual(contentType, .json)// comparison content and json
            XCTAssertNotNil(res.content)// content != nil
            XCTAssertContent(UserResponse.self, res) { (content) in// decode
                userID = content.id //
                XCTAssertEqual(userRequestU.name, content.name)// content value comparison
                XCTAssertEqual(userRequestU.username, content.username)
                XCTAssertEqual(userRequestU.patronymic, content.patronymic)
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
    
    
    
    func testGetAllUser() throws {
        let app = Application(.testing)// service setup
        defer { app.shutdown() }// service setup
        try configure(app)// service setup
        let userRequest = CreateUserRequest(name: "K", username: "H", patronymic: "O")
        var userID: UUID?
        try app.test(.POST, "/v1/users",beforeRequest: { req in// req test
            try req.content.encode(userRequest) // code data
        }, afterResponse: { res in// response comparison
            XCTAssertEqual(res.status, .ok)
            let contentType = try XCTUnwrap(res.headers.contentType) //get content type
            XCTAssertEqual(contentType, .json)// comparison content and json
            XCTAssertNotNil(res.content)// content != nil
            XCTAssertContent(UserResponse.self, res) { (content) in// decode
                userID = content.id
                XCTAssertEqual(userRequest.name, content.name)// content value comparison
                XCTAssertEqual(userRequest.username, content.username)
                XCTAssertEqual(userRequest.patronymic, content.patronymic)
            }
        })
        let userRequest2 = CreateUserRequest(name: "J2", username: "H2", patronymic: "N2")
            var userID2: UUID?
            try app.test(.POST, "/v1/users",beforeRequest: { req in// req test
                try req.content.encode(userRequest2) // code data
            }, afterResponse: { res in// response comparison
                XCTAssertEqual(res.status, .ok)
                let contentType = try XCTUnwrap(res.headers.contentType) //get content type
                XCTAssertEqual(contentType, .json)// comparison content and json
                XCTAssertNotNil(res.content)// content != nil
                XCTAssertContent(UserResponse.self, res) { (content) in// decode
                    userID2 = content.id
                    XCTAssertEqual(userRequest2.name, content.name)// content value comparison
                    XCTAssertEqual(userRequest2.username, content.username)
                    XCTAssertEqual(userRequest2.patronymic, content.patronymic)
                }
            })
            try app.test(.GET, "/v1/users/all", afterResponse: { (res) in
                XCTAssertEqual(res.status, .ok)
                let contentType = try XCTUnwrap(res.headers.contentType)
                XCTAssertEqual(contentType, .json)
                XCTAssertNotNil(res.content)
                XCTAssertContent(UserResponse.self, res) { (content) in// decode
                    XCTAssertEqual(userRequest.name, content.name)// content comparison
                    XCTAssertEqual(userRequest.username, content.username)
                    XCTAssertEqual(userRequest.patronymic, content.patronymic)
                    XCTAssertContent(UserResponse.self, res) { (content) in// decode
                        XCTAssertEqual(userRequest2.name, content.name)// content comparison
                        XCTAssertEqual(userRequest2.username, content.username)
                        XCTAssertEqual(userRequest2.patronymic, content.patronymic)
                    }
                }
            })
            try app.autoRevert().wait()
        }
/
    
    
    
    
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
