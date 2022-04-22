import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    let usersRoute = app.grouped("v1", "users")
    let usersController = UsersController()
    try usersRoute.register(collection: usersController)
    let carController = CarController()
    try usersRoute.register(collection: carController)
    let wheelsController = WheelsController()
    try usersRoute.register(collection: wheelsController)
}
