import Vapor
import Fluent

struct UsersController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        routes.post(use: createHandler)
        routes.patch(":userID", use: updateHandler)
        routes.get(":userID", use: getHandler)
        routes.get(":userID", "all", use: getAllHandler)
        routes.delete(":userID", "force", use: forceDeleteHandler) //
        routes.delete(":userID", "soft", use: softDeleteModelHandler) //
    }
    
    
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<User> {
        let content = try req.content.decode(CreateUserRequest.self)
        let user = User(name: content.name ?? "",
                        username: content.username ?? "",
                        patronymic: content.patronymic ?? "")
        return user.create(on: req.db).map { user }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func updateHandler(_ req: Request) throws -> EventLoopFuture<User> {
        let content = try req.content.decode(UpdateUserRequest.self)
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.notModified)
        }
        return User.query(on: req.db)
            .filter(\User.$id == userID)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                
                if let name = content.name {
                    user.name = name
                }
                if let username = content.name {
                    user.username = username
                }
                if let patronymic = content.patronymic {
                    user.patronymic = patronymic
                }
                return user.update(on: req.db(.psql)).map { user }
            } }
    
    
    func getHandler(_ req: Request) throws -> EventLoopFuture<User> {
        guard req.parameters.get("userID", as: UUID.self) != nil else {
            throw Abort(.badRequest)
        }
        return User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    
    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[User]> {
        User.query(on: req.db).all()
    }
    
    
    func forceDeleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.notFound)
        }
        return  User.query(on: req.db)
            .filter(\User.$id == userID)
            .delete(force: true)
            .transform(to: HTTPStatus.noContent)
    }
    
    
    
    func softDeleteModelHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.notFound)//400 не валидн
        }
        return User.query(on: req.db)
            .filter(\.$id == userID)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { user in //user це є константа
                user.delete(force: false, on: req.db).transform(to: HTTPStatus.noContent)
            } // on: req.db запрос в базу данних
    } // достаю всю модель, потом видаляю (безпечний варіант, була модель в базі чи ні)
    
}
