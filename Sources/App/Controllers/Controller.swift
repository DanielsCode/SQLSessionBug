import Vapor
import Leaf
import Authentication

struct Controller: RouteCollection {
    func boot(router: Router) throws {
        
        router.post("user", use: createHandler)
        // router.get(use: postHandler) - this works
        
        // Implement Session Security
        let authSessionRoutes = router.grouped(User.authSessionsMiddleware())
        
        authSessionRoutes.get("login", use: loginHandler)
        authSessionRoutes.post("login", use: loginPostHandler)
        authSessionRoutes.post("logout", use: logoutHandler)
        
        let protectedRoutes = authSessionRoutes.grouped(RedirectMiddleware<User>(path: "/login"))
        protectedRoutes.get(use: postHandler)
    }
    


    
    func postHandler(_ req: Request) throws -> Future<View> {
        let logger = try req.make(Logger.self)
        logger.debug("postHandler Start")
        let stopwatch = Stopwatch()
        return req.withPooledConnection(to: .mysql) { conn in
            return conn.raw("""
                SELECT Post.*, count(Comment.postId) AS numberOfComments
                FROM Post LEFT JOIN Comment ON (Post.id = Comment.postId)
                GROUP BY Post.id ORDER BY numberOfComments DESC
                """).all(decoding: Post.self).flatMap(to: View.self) { posts in
                    logger.debug("postHandler Get Post informations")

                    
                    let context = PostContext(title: "Post", posts: posts)
                    logger.debug("postHandler Finished within \(stopwatch.stop()) seconds")
                    return try req.view().render("index", context)
            }
        }
    }
    
    func createHandler(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap(to: User.self) { user in
            user.password = try BCrypt.hash(user.password)
            return user.save(on: req)
        }
    }
    
    // MARK: Login Stuff
    func loginHandler(_ req: Request) throws -> Future<View> {
        let context: LoginContext
        let logger = try req.make(Logger.self)
        logger.debug("Login Handler Start")
        let stopwatch = Stopwatch()
        if req.query[Bool.self, at: "error"] != nil {
            context = LoginContext(loginError: true)
        } else {
            context = LoginContext()
        }
        logger.debug("Login Handler Finished within \(stopwatch.stop()) seconds")
        return try req.view().render("login", context)
    }
    
    func loginPostHandler(_ req: Request) throws -> Future<Response> {
        let logger = try req.make(Logger.self)
        logger.debug("loginPostHandler Start")
        let stopwatch = Stopwatch()
        return try req.content.decode(LoginPostData.self).flatMap(to: Response.self) { data in
            return User.authenticate(username: data.username, password: data.password, using: BCryptDigest(), on: req).map(to: Response.self) { user in
                guard let user = user else {
                    logger.debug("User or password is wrong")
                    logger.debug("loginPostHandler Finished within \(stopwatch.stop()) seconds")
                    return req.redirect(to: "/login?error")
                }
                try req.authenticateSession(user)
                logger.debug("User is logged in")
                logger.debug("loginPostHandler Finished within \(stopwatch.stop()) seconds")
                return req.redirect(to: "/")
            }
        }
    }
    
    func logoutHandler(_ req: Request) throws -> Response {
        try req.unauthenticateSession(User.self)
        return req.redirect(to: "/")
    }
}


// MARK: Context / LEAF

struct PostContext: Encodable {
    let title: String
    let posts: [Post]?
}


struct LoginContext: Encodable {
    let title = "Log In"
    let loginError: Bool
    
    init(loginError: Bool = false) {
        self.loginError = loginError
    }
}

struct LoginPostData: Content {
    let username: String
    let password: String
}



// MARK: Debug Helper

struct Stopwatch {
    var startTime: Date
    
    init() {
        self.startTime = Date()
    }
    
    func stop() -> Double {
        let now = Date()
        return now.timeIntervalSince(startTime)
    }
}




