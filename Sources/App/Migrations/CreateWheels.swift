import Fluent

struct CreateWheels: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("wheels")
            .id()
        
            .field("frontLeft", .string, .required)
            .field("frontRight", .string, .required)
            .field("rearLeft", .string, .required)
            .field("rearRight", .string, .required)
            .field("car_id", .uuid, .required, .references(Car.schema, .id, onDelete: .cascade, onUpdate: .noAction))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("wheels").delete()
    }
}

