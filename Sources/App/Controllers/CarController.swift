import Vapor
import Fluent
import Foundation

struct CarController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        routes.post(":userID","cars", use: createCarHandler)
        routes.patch(":userID","cars",":carID", use: updateCarHandler)
        routes.get(":userID","cars",":carID", use: getCarHandler)
        routes.get(":userID", "cars", use: getAllCarHandler)
        routes.delete(":userID","cars",":carID","force", use: forceDeleteCarHandler)
        routes.delete(":userID","cars",":carID", use: softDeleteModelCarHandler)
    }
    
    
    func createCarHandler(_ req: Request) throws -> EventLoopFuture<Car> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let content = try req.content.decode(CreateCarRequest.self)
        let car = Car(name: content.name ?? "",
                      number: content.number ?? 0)
        return User.query(on: req.db(.psql))
            .filter(\.$id == userID)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                return user.$car.create([car], on: req.db).map { car }
            }
    }
    
  
    
    func updateCarHandler(_ req: Request) throws -> EventLoopFuture<Car> {
        let content = try req.content.decode(UpdateCarRequest.self)
        guard let userId = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let carID = req.parameters.get("carID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return User.query(on: req.db)
            .filter(\User.$id == userId)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                let userID = user.id
                return Car.query(on: req.db)
                    .filter(\Car.$user.$id == userID!)
                    .filter(\.$id == carID)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { car in
                        if let name = content.name {
                            car.name = name
                        }
                        if let number = content.number {
                            car.number = number
                        }
                        return car.update(on: req.db(.psql))
                            .map { car }
                    }
            }
    }
    
    
    func getAllCarHandler(_ req: Request) throws -> EventLoopFuture<[Car]> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        return Car.query(on: req.db)
            .filter(\Car.$user.$id == userID)
            .all()
    }
    
    
    
    func getCarHandler(_ req: Request) throws -> EventLoopFuture<Car> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.noContent)
        }
        guard let carID = req.parameters.get("carID", as: UUID.self) else {
            throw Abort(.noContent)
        }
        return User.query(on: req.db)
            .filter(\User.$id == userID)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { _ in
                Car.query(on: req.db)
                    .filter(\Car.$id == carID)
                    .first()
                    .unwrap(or: Abort(.notFound))
                
            }
        
    }
    
    func forceDeleteCarHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.noContent)
        }
        guard let carID = req.parameters.get("carID", as: UUID.self) else {
            throw Abort(.noContent)
        }
        return User.query(on: req.db)
            .filter(\User.$id == userID)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { _ in
                Car.query(on: req.db)
                    .filter(\Car.$user.$id == userID)
                    .filter(\Car.$id == carID)
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
        return Car.query(on: req.db)
            .filter(\Car.$id == carID)
            .filter(\Car.$user.$id == userID)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { car in
                car.delete(force: false, on: req.db).transform(to: HTTPStatus.noContent)
            }
    }
    
    
}


