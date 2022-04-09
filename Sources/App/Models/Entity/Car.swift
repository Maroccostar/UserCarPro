import Fluent
import Vapor

final class Car: Model, Content {
    
    static let schema = "cars"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "number")
    var number: Int?
    
    @Parent(key: "user_id")
    var user: User
    
    init() {}
    
    init(id: UUID? = nil, name: String, number: Int? = nil, userID: UUID? = nil) { //new
        self.id = id //new
        self.name = name
        self.number = number
        self.$user.id = userID! // изминения
    }
    
}
