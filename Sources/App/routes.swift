import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let controller = Controller()
    try router.register(collection: controller)

}
