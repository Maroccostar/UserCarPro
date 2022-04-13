import Vapor
import Fluent
import Foundation

struct CarController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        routes.post(":userID","cars", use: createCarHandler)
        routes.patch(":userID","cars",":carID", use: updateCarHandler)
        routes.get(":userID","cars",":carID", use: getCarHandler)
        routes.get(":userID", "cars","all", use: getAllCarHandler)
        routes.delete(":userID","cars",":carID","force", use: forceDeleteCarHandler)
        routes.delete(":userID","cars",":carID", use: softDeleteModelCarHandler)
    }
    
    
    
    func createCarHandler(_ req: Request) throws -> EventLoopFuture<CarResponse> {//CarResponse
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        try CreateCarRequest.validate(content: req) // new validations
        let content = try req.content.decode(CreateCarRequest.self)// CreateCarRequest
        let car = Car(name: content.name ?? "",
                      number: content.number ?? 0)
        return req.userService.getUser(userID: userID) // Request+Extension
            .flatMap { user in
                return user.$car.create([car], on: req.db).map { car }
                .map { createCar in
                    return CarResponse(car: createCar)//CarResponse
                }
            }
    }
    
    
    
    
    func updateCarHandler(_ req: Request) throws -> EventLoopFuture<CarResponse> { //CarResponse
        let content = try req.content.decode(UpdateCarRequest.self)
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let carID = req.parameters.get("carID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        try UpdateCarRequest.validate(content: req) // new validations
        return req.userService.getUser(userID: userID)
            .flatMap { user in
                let userID = user.id
                return Car.query(on: req.db)
                    .group(.and, { group in
                        group.filter(\Car.$user.$id == userID!).filter(\.$id == carID)// group
                    })
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { car in
                        if let name = content.name {
                            car.name = name
                        }
                        if let number = content.number {
                            car.number = number
                        }
                        return car.update(on: req.db(.psql)).map { car }
                        .map { createCar in
                            return CarResponse(car: createCar)//CarResponse
                        }
                        
                    }
            }
    }
    
    
    
    
    func getAllCarHandler(_ req: Request) throws -> EventLoopFuture<[Car]> { //CarResponse
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.userService.getUser(userID: userID)
            .flatMap { _ in
                Car.query(on: req.db)
                    .filter(\Car.$user.$id == userID)
                    .all()
                //                    .map { createCar in
                //                        return CarResponse(car: createCar)//CarResponse
                //                    }
            }
    }
    
    
    
    func getCarHandler(_ req: Request) throws -> EventLoopFuture<CarResponse> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.noContent)
        }
        guard let carID = req.parameters.get("carID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return req.userService.getUser(userID: userID)
            .flatMap { _ in
                Car.query(on: req.db)
                    .filter(\Car.$id == carID)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .map { createCar in
                        return CarResponse(car: createCar)//CarResponse
                    }
            }
    }
    
    
    
    func forceDeleteCarHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.noContent)
        }
        guard let carID = req.parameters.get("carID", as: UUID.self) else {
            throw Abort(.noContent)
        }
        return req.userService.getUser(userID: userID)
            .flatMap { _ in
                Car.query(on: req.db)
                    .group(.and, { group in
                        group.filter(\Car.$user.$id == userID).filter(\Car.$id == carID)// group
                    })
                    .delete(force: true).transform(to: HTTPStatus.noContent)
            }
        
    }
    
    
    func softDeleteModelCarHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.noContent)
        }
        guard let carID =  req.parameters.get("carID", as: UUID.self) else {
            throw Abort(.noContent)
        }
        return req.userService.getUser(userID: userID)
            .flatMap { user in
                Car.query(on: req.db)
                    .group(.and, { group in
                        group.filter(\Car.$id == carID).filter(\Car.$user.$id == userID)//group
                    })
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { car in
                        car.delete(force: false, on: req.db).transform(to: HTTPStatus.noContent)
                    }
            }
    }
    
    
}


