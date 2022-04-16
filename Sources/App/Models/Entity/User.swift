import Fluent
import Vapor

final class User: Model, Content {
    
    static let schema = "users"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "patronymic")
    var patronymic: String
    
//    @Field(key: "create_add")
//    var create_add: String
//
//    @Field(key: "update_add")
//    var update_add: String
//
//    @Field(key: "delete_add")
//    var delete_add: String
    
    @Children(for: \.$user)
    var car: [Car]
    
    init() {}
    
    init(id: UUID? = nil, name: String, username: String, patronymic: String) {
        self.id = id
        self.name = name
        self.username = username
        self.patronymic = patronymic
        //self.create_add = create_add
        //self.update_add = update_add
        //self.delete_add = delete_add
        
    }
}
