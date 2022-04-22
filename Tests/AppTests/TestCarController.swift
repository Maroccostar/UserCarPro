
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

final class TestCarController: XCTestCase {
    
    func testCreateCar() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        let userRequest = CreateUserRequest(name: "H", username: "L", patronymic: "D")
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
        let carRequest = CreateCarRequest(name: "Car", number: 1)
        var carID: UUID?
        try app.test(.POST, "/v1/users/\(userID!)/cars",beforeRequest: { req in
            try req.content.encode(carRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let contentType = try XCTUnwrap(res.headers.contentType)
            XCTAssertEqual(contentType, .json)
            XCTAssertNotNil(res.content)
            XCTAssertContent(CarResponse.self, res) { (content) in
                carID = content.id
                XCTAssertEqual(carRequest.name, content.name)
                XCTAssertEqual(carRequest.number, content.number)
            }
        })
        try app.test(.GET, "/v1/users/\(userID!)/cars/\(carID!)",afterResponse: { (res) in
            XCTAssertEqual(res.status, .ok)
            let contentType = try XCTUnwrap(res.headers.contentType)
            XCTAssertEqual(contentType, .json)
            XCTAssertNotNil(res.content)// != nil
            XCTAssertContent(CarResponse.self, res) { (content) in// decode
                XCTAssertEqual(carRequest.name, content.name)
                XCTAssertEqual(carRequest.number, content.number)
            }
        })
        try app.autoRevert().wait()
    }
    
    
    
    func testUpdateCar() throws {
        let app = Application(.testing)// service setup
        defer { app.shutdown() }// service setup
        try configure(app)// service setup
        let userRequest = CreateUserRequest(name: "D", username: "R", patronymic: "S")
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
        let carRequest = CreateCarRequest(name: "Ford", number: 5)
        var carID: UUID?
        try app.test(.POST, "/v1/users/\(userID!)/cars",beforeRequest: { req in
            try req.content.encode(carRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let contentType = try XCTUnwrap(res.headers.contentType)
            XCTAssertEqual(contentType, .json)
            XCTAssertNotNil(res.content)
            XCTAssertContent(CarResponse.self, res) { (content) in
                carID = content.id
                XCTAssertEqual(carRequest.name, content.name)
                XCTAssertEqual(carRequest.number, content.number)
            }
        })
        try app.test(.GET, "/v1/users/\(userID!)/cars/\(carID!)",afterResponse: { (res) in
            XCTAssertEqual(res.status, .ok)
            let contentType = try XCTUnwrap(res.headers.contentType)
            XCTAssertEqual(contentType, .json)
            XCTAssertNotNil(res.content)// != nil
            XCTAssertContent(CarResponse.self, res) { (content) in// decode
                XCTAssertEqual(carRequest.name, content.name)
                XCTAssertEqual(carRequest.number, content.number)
            }
        })
        let carRequest2 = UpdateCarRequest(name: "Car2", number: 2)
        try app.test(.PATCH, "/v1/users/\(userID!)/cars/\(carID!)",beforeRequest: { req in// req test
            try req.content.encode(carRequest2) // code data
        }, afterResponse: { res in// response comparison
            XCTAssertEqual(res.status, .ok)
            let contentType = try XCTUnwrap(res.headers.contentType) //get content type
            XCTAssertEqual(contentType, .json)// comparison content and json
            XCTAssertNotNil(res.content)// content != nil
            XCTAssertContent(CarResponse.self, res) { (content) in// decode
                carID = content.id //
                XCTAssertEqual(carRequest2.name, content.name)
                XCTAssertEqual(carRequest2.number, content.number)
            }
        })
        try app.autoRevert().wait()
    }
    
    
    
    
    func testGetCar() throws {
        let app = Application(.testing)// service setup
        defer { app.shutdown() }// service setup
        try configure(app)// service setup
        let userRequest = CreateUserRequest(name: "R", username: "S", patronymic: "T")
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
        let carRequest = CreateCarRequest(name: "Fiat", number: 4)
        var carID: UUID?
        try app.test(.POST, "/v1/users/\(userID!)/cars",beforeRequest: { req in
            try req.content.encode(carRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let contentType = try XCTUnwrap(res.headers.contentType)
            XCTAssertEqual(contentType, .json)
            XCTAssertNotNil(res.content)
            XCTAssertContent(CarResponse.self, res) { (content) in
                carID = content.id
                XCTAssertEqual(carRequest.name, content.name)
                XCTAssertEqual(carRequest.number, content.number)
            }
        })
        try app.test(.GET, "/v1/users/\(userID!)/cars/\(carID!)",afterResponse: { (res) in
            XCTAssertEqual(res.status, .ok)
            let contentType = try XCTUnwrap(res.headers.contentType)
            XCTAssertEqual(contentType, .json)
            XCTAssertNotNil(res.content)// != nil
            XCTAssertContent(CarResponse.self, res) { (content) in// decode
                XCTAssertEqual(carRequest.name, content.name)
                XCTAssertEqual(carRequest.number, content.number)
            }
        })
        try app.autoRevert().wait()
    }
    
    
    
//    func testGetAllUser() throws {
//        let app = Application(.testing)// service setup
//        defer { app.shutdown() }// service setup
//        try configure(app)// service setup
//        let userRequest = CreateUserRequest(name: "Vasil", username: "Homenko", patronymic: "Vasilovich")
//        //var userID: UUID?
//        try app.test(.POST, "/v1/users",beforeRequest: { req in// req test
//            try req.content.encode(userRequest) // code data
//        }, afterResponse: { res in// response comparison
//            XCTAssertEqual(res.status, .ok)
//            let contentType = try XCTUnwrap(res.headers.contentType) //get content type
//            XCTAssertEqual(contentType, .json)// comparison content and json
//            XCTAssertNotNil(res.content)// content != nil
//            XCTAssertContent(UserResponse.self, res) { (content) in// decode
//                //userID = content.id
//                XCTAssertEqual(userRequest.name, content.name)// content value comparison
//                XCTAssertEqual(userRequest.username, content.username)
//                XCTAssertEqual(userRequest.patronymic, content.patronymic)
//            }
//        })
//            let userRequest2 = CreateUserRequest(name: "Vasil2", username: "Homenko2", patronymic: "Vasilovich2")
//            //var userID2: UUID?
//            try app.test(.POST, "/v1/users",beforeRequest: { req in// req test
//                try req.content.encode(userRequest2) // code data
//            }, afterResponse: { res in// response comparison
//                XCTAssertEqual(res.status, .ok)
//                let contentType = try XCTUnwrap(res.headers.contentType) //get content type
//                XCTAssertEqual(contentType, .json)// comparison content and json
//                XCTAssertNotNil(res.content)// content != nil
//                XCTAssertContent(UserResponse.self, res) { (content) in// decode
//                   // userID2 = content.id
//                    XCTAssertEqual(userRequest2.name, content.name)// content value comparison
//                    XCTAssertEqual(userRequest2.username, content.username)
//                    XCTAssertEqual(userRequest2.patronymic, content.patronymic)
//                }
//            })
//            try app.test(.GET, "/v1/users/all", afterResponse: { (res) in
//                XCTAssertEqual(res.status, .ok)
//                let contentType = try XCTUnwrap(res.headers.contentType)
//                XCTAssertEqual(contentType, .json)
//                XCTAssertNotNil(res.content)// != nil
//                //let content = try res.content.decode(UserResponse.self)
//                //_ = try res.content.decode([UserResponse].self)
//                XCTAssertContent(UserResponse.self, res) { (content) in// decode
//                    //_ = try res.content.decode([UserResponse].self)
//                    XCTAssertEqual(userRequest.name, content.name)// content comparison
//                    XCTAssertEqual(userRequest.username, content.username)
//                    XCTAssertEqual(userRequest.patronymic, content.patronymic)
//                    XCTAssertContent(UserResponse.self, res) { (content) in// decode
//                        XCTAssertEqual(userRequest2.name, content.name)// content comparison
//                        XCTAssertEqual(userRequest2.username, content.username)
//                        XCTAssertEqual(userRequest2.patronymic, content.patronymic)
//                    }
//                }
//            })
//            try app.autoRevert().wait()
//        }
//
    
    
    
    
    func testDeleteUser() throws {
        let app = Application(.testing)// service setup
        defer { app.shutdown() }// service setup
        try configure(app)// service setup
        let userRequest = CreateUserRequest(name: "G", username: "E", patronymic: "T")
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
        let carRequest = CreateCarRequest(name: "Auto", number: 3)
        var carID: UUID?
        try app.test(.POST, "/v1/users/\(userID!)/cars",beforeRequest: { req in
            try req.content.encode(carRequest)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let contentType = try XCTUnwrap(res.headers.contentType)
            XCTAssertEqual(contentType, .json)
            XCTAssertNotNil(res.content)
            XCTAssertContent(CarResponse.self, res) { (content) in
                carID = content.id
                XCTAssertEqual(carRequest.name, content.name)
                XCTAssertEqual(carRequest.number, content.number)
            }
        })
        try app.test(.DELETE, "/v1/users/\(userID!)/cars/\(carID!)/force/",afterResponse: { (res) in
            XCTAssertEqual(res.status, .noContent) //возв только notFound не  noContent
        })
        try app.autoRevert().wait()
    }
    
}
