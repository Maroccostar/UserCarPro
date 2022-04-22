import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    
    let databaseName: String
    let databasePort: Int
    if (app.environment == .testing) {
        databaseName = "vapor-test"
        if let testPort = Environment.get("DATABASE_PORT") {
            databasePort = Int(testPort) ?? 5433
        } else {
            databasePort = 5433
        }
    } else {
        databaseName = "vapor_database"
        databasePort = 5432
    }
    
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: databasePort,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? databaseName
    ), as: .psql)
    
    // MARK: - migrations
    
    app.migrations.add(CreateUser()) //РЕГИСТРАЦИЯ МИГРАЦИИ
    app.migrations.add(CreateCar()) // РЕГИСТРАЦИЯ РЕБЕНКА
    app.migrations.add(CreateWheels()) // РЕГИСТРАЦИЯ КОЛЕС
    app.logger.logLevel = .info//.debug
    try app.autoMigrate().wait()
    try routes(app)
    try middlewares(app)
}


















//    guard let hostName = Environment.get("DATABASE_HOST") else {
//        fatalError("hostName Error")
//        return
//    }
//
//    let databaseName: String
//    let databasePort: Int
//    if (app.environment == .testing) {
//        databaseName = "vapor-test"
//        if let testPort = Environment.get("DATABASE_PORT") {
//            databasePort = Int(testPort) ?? 5433
//        } else {
//            databasePort = 5433
//        }
//    } else {
//        databaseName = "vapor_database"
//        databasePort = 5432
//    }
//
//    guard let userName = Environment.get("DATABASE_USERNAME") else {
//        fatalError("vapor_username Error")
//        return
//    }
//    guard let dataBasePassword = Environment.get("DATABASE_PASSWORD") else {
//        fatalError("vapor_password Error")
//        return
//    }
//    guard let databaseName = Environment.get("DATABASE_NAME") else {
//        fatalError("databaseName Error")
//        return
//    }
//
//
//    app.databases.use(.postgres(
//        hostname: hostName,
//        port: databasePort,
//        username: userName,
//        password: dataBasePassword,
//        database: databaseName
//    ), as: .psql)

//    app.databases.use(.postgres(
//        hostname: Environment.get("DATABASE_HOST")
//        ?? "localhost",
//        username: Environment.get("DATABASE_USERNAME")
//        ?? "vapor_username",
//        password: Environment.get("DATABASE_PASSWORD")
//        ?? "vapor_password",
//        database: Environment.get("DATABASE_NAME")
//        ?? "vapor_database"
//    ), as: .psql)

//public func configure(_ app: Application) throws {
//
//    guard let dataBaseHost = Environment.get("DATABASE_HOST") else {
//        fatalError("databaseHost Error")
//        return
//    }
//
//    app.databases.use(.postgres(
//        hostname: dataBaseHost,
//        port: dataBaseHost,// строка в число преобраз guard або if
//        username: dataBaseHost,
//        password: dataBaseHost,
//        database: dataBaseHost), as: .psql)




