import Fluent

struct CreateCar: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("cars")
            .id()
            .field("name", .string, .required)
            .field("number", .int, .required)
            .field("user_id", .uuid, .required, .references(User.schema, .id, onDelete: .cascade, onUpdate: .noAction))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("cars").delete()
    }
}
