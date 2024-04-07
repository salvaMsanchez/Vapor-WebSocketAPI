//
//  File.swift
//  
//
//  Created by Salva Moreno on 7/4/24.
//

import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("user") { builder in
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                builder.get("id", use: userId)
            }
        }
    }
}

extension UserController {
    func userId(req: Request) async throws -> User.Public {
        // Get user email
        if let userEmail = req.headers.first(name: "Email") {
            // Find user on db
            guard let user = try await User
                .query(on: req.db)
                .filter(\.$email == userEmail)
                .first() else {
                throw Abort(.badRequest)
            }
            
            return User.Public(id: user.id)
        } else {
            throw Abort(.badRequest)
        }
    }
}
