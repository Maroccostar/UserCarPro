import Fluent

struct CreateUser: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("username", .string, .required)
            .field("patronymic", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
