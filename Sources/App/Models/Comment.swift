import FluentMySQL
import Vapor

final class Comment: Codable {
    
    typealias ID = String
    var id: String?
    var postId: Post.ID
    var text: String?
    
    // Just a helper one
    var numberOfComments: Int?
    
    
    init(id: String, text: String, postId: Post.ID) {
        self.id = id
        self.text = text
        self.postId = postId
    }
}

extension Comment: MySQLStringModel {}
extension Comment: Content {}
extension Comment: Migration {}
extension Comment: Parameter {}

extension Comment {
    var components: Parent <Comment, Post> {
        return parent(\.postId)
    }
}
