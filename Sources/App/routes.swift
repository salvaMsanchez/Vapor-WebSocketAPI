import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.group("api", "v1") { builder in
        try builder.group(APIKeyMiddleware()) { builder in
            try builder.register(collection: AuthController())
            try builder.register(collection: UserController())
            try builder.register(collection: MessagesController())
            try builder.register(collection: PhotoController())
            try builder.register(collection: SearchController())
        }
    }
}
