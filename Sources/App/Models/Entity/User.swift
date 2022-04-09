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
    
    @Children(for: \.$user)//new
    var car: [Car]
    
    
    init() {}
    
    init(id: UUID? = nil, name: String, username: String, patronymic: String) { //new
        self.id = id //new
        self.name = name
        self.username = username
        self.patronymic = patronymic
    }
}
