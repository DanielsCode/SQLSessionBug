import FluentMySQL
import Vapor

final class Post: Codable {
    
    typealias ID = String
    var id: String?
    var title: String?
    var text: String?
    
    // Just a helper one
    var numberOfComments: Int?
    
    
    init(id: String, title: String, text: String) {
        self.id = id
        self.title = title
        self.text = text
    }
}

extension Post: MySQLStringModel {}
extension Post: Content {}
extension Post: Migration {
    
    
    /// See Migration.prepare
    /// Manual prepare to avoid the create of helper properties like numberOfComponents
    static func prepare(on connection: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(self, on: connection) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.title)
            builder.field(for: \.text)
        }
    }
}
extension Post: Parameter {}

extension Post {
    var components: Children <Post, Comment> {
        return children(\.postId)
    }
}


