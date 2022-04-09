import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    let usersRoute = app.grouped("v1", "users")
    let usersController = UsersController()
    try usersRoute.register(collection: usersController)
    
}
