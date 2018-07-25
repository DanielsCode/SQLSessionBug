import FluentMySQL
import Vapor
import Leaf
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentProvider())
    try services.register(FluentMySQLProvider())
    
    
    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(SessionsMiddleware.self)
    services.register(middlewares)
    
    
    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    let mysqlConfig = MySQLDatabaseConfig(hostname: "localhost", port: 3306, username: "dbuser", password: "dbpassword", database: "database")

    databases.enableLogging(on: .mysql)
    let database = MySQLDatabase(config: mysqlConfig)
    databases.add(database: database, as: .mysql)
    services.register(databases)
    
    /// Register Template Engine LEAF
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)


    // Register Authentication
    try services.register(AuthenticationProvider())
    
    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Post.self, database: .mysql)
    migrations.add(model: Comment.self, database: .mysql)
    migrations.add(model: User.self, database: .mysql)
    services.register(migrations)
    
    // Port definition
    let myService = NIOServerConfig.default(hostname: "0.0.0.0", port: 8080)
    //let myService = NIOServerConfig.default(hostname: "localhost", port: 8080)
    services.register(myService)
    
    User.Public.defaultDatabase = .mysql
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Enable Sessions for WebApp
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
}
