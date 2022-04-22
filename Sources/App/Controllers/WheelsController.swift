import Vapor
import Fluent
import Foundation

struct WheelsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        routes.post(":userID","cars",":carID","wheels", use: createWheelsHandler)
        routes.patch(":userID","cars",":carID","wheels",":wheelsID", use: updateWheelsHandler)
        routes.get(":userID","cars",":carID","wheels",":wheelsID", use: getWheelsHandler)
        routes.get(":userID", "cars",":carID","wheels","all", use: getAllWheelsHandler)
        routes.delete(":userID","cars",":carID","wheels",":wheelsID","force", use: forceDeleteWheelsHandler)
        routes.delete(":userID","cars",":carID","wheels",":wheelsID","soft", use: softDeleteModelWheelsHandler)
    }
    
    
    
    func createWheelsHandler(_ req: Request) throws -> EventLoopFuture<WheelsResponse> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let carID = req.parameters.get("carID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        try CreateWheelsRequest.validate(content: req)
        let content = try req.content.decode(CreateWheelsRequest.self)
        let wheel = Wheels(frontLeft: content.frontLeft ?? "",
                           frontRight: content.frontRight ?? "",
                           rearLeft: content.rearLeft ?? "",
                           rearRight: content.rearRight ?? "")
        return req.userService.getUser(userID: userID)
            .flatMap { _ in
                Car.query(on: req.db)
                    .filter(\Car.$id == carID)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { car in
                        return car.$wheel.create([wheel], on: req.db).map { wheel }
                        .map { CreateWheels in
                            return WheelsResponse(wheel: CreateWheels)
                        }
                    }
            }
    }
    
    
    func updateWheelsHandler(_ req: Request) throws -> EventLoopFuture<WheelsResponse> {
        let content = try req.content.decode(UpdateWheelsRequest.self)
        
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let carID = req.parameters.get("carID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let wheelsID = req.parameters.get("wheelsID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        try UpdateWheelsRequest.validate(content: req)
        return req.userService.getUser(userID: userID)
            .flatMap { user in
                return Wheels.query(on: req.db)
                    .group(.and, { group in
                        group.filter(\Wheels.$car.$id == carID)
                            .filter(\Wheels.$id == wheelsID)
                    })
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { wheel in
                        if let frontLeft = content.frontLeft {
                            wheel.frontLeft = frontLeft
                        }
                        if let frontRight = content.frontRight {
                            wheel.frontRight = frontRight
                        }
                        if let rearLeft = content.rearLeft {
                            wheel.rearLeft = rearLeft
                        }
                        if let rearRight = content.rearRight {
                            wheel.rearRight = rearRight
                        }
                        return wheel.update(on: req.db(.psql)).map { wheel }
                        .map { CreateWheels in
                            return WheelsResponse(wheel: CreateWheels)
                        }
                        
                    }
            }
    }
    
    func getWheelsHandler(_ req: Request) throws -> EventLoopFuture<WheelsResponse> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let carID = req.parameters.get("carID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let wheelsID = req.parameters.get("wheelsID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.userService.getUser(userID: userID)
            .flatMap { _ in
                Wheels.query(on: req.db)
                    .filter(\Wheels.$car.$id == carID)
                    .filter(\Wheels.$id == wheelsID)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .map { CreateWheels in
                        return WheelsResponse(wheel: CreateWheels)
                    }
            }
    }
    
    
    
    func getAllWheelsHandler(_ req: Request) throws -> EventLoopFuture<[WheelsResponse]> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let carID = req.parameters.get("carID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.userService.getUser(userID: userID)
            .flatMap { _ in
                Wheels.query(on: req.db)
                    .filter(\Wheels.$car.$id == carID)
                    .all()
                    .map { createWheels in
                        createWheels.map { wheel in
                            WheelsResponse(wheel: wheel)
                        }
                    }
            }
    }
    
    
    func forceDeleteWheelsHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let carID = req.parameters.get("carID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let wheelsID = req.parameters.get("wheelsID", as: UUID.self) else {
            throw Abort(.notFound)
        }
        return req.userService.getUser(userID: userID)
            .flatMap { _ in
                Wheels.query(on: req.db)
                    .group(.and, { group in
                        group.filter(\Wheels.$car.$id == carID)
                            .filter(\Wheels.$id == wheelsID)
                    })
                    .delete(force: true).transform(to: HTTPStatus.noContent)
            }
    }
    
    
    
    func softDeleteModelWheelsHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let carID =  req.parameters.get("carID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let wheelsID = req.parameters.get("wheelsID", as: UUID.self) else {
            throw Abort(.notFound)
        }
        return req.userService.getUser(userID: userID)
            .flatMap { user in
                Wheels.query(on: req.db)
                    .group(.and, { group in
                        group.filter(\Wheels.$car.$id == carID)
                            .filter(\Wheels.$id == wheelsID)
                    })
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { wheel in
                        wheel.delete(force: false, on: req.db).transform(to: HTTPStatus.noContent)
                    }
            }
    }
}

