import FluentMySQL
import Vapor
import Authentication


final class User: Codable {
    
    var id: Int?
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    final class Public: Codable {
        var id: Int?
        var username: String
        
        init(username: String) {
            self.username = username
        }
    }
}
extension User.Public: MySQLModel {
    static let entity = User.entity
}

extension User.Public: Content { }
extension User: MySQLModel{}
extension User: Content {}
extension User: Migration {}

// Auth Stuff

// API Login
extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \User.username
    static let passwordKey: PasswordKey = \User.password
}

// Web Login
extension User: PasswordAuthenticatable {}
extension User: SessionAuthenticatable {}



