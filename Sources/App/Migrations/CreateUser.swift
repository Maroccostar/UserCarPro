import Fluent

struct CreateUser: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("username", .string, .required)
            .field("patronymic", .string, .required)
//            .field("create_add", .datetime) // new
//            .field("update_add", .datetime)// new
//            .field("delete_add", .datetime)// new
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
