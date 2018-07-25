// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SQLSessionBug",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on MySQL
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0-rc.2"),

        // 🔵 Fluent Template Engine to render HTML
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0-rc.2"),

        // Use authentication
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0-rc")
        
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentMySQL", "Vapor","Leaf", "Authentication"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
