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
                builder.get("info", ":id", use: userInfo)
            }
        }
    }
}

extension UserController {
    func userId(req: Request) async throws -> User.Id {
        // Get user email
        if let userEmail = req.headers.first(name: "Email") {
            // Find user on db
            guard let user = try await User
                .query(on: req.db)
                .filter(\.$email == userEmail)
                .first() else {
                throw Abort(.badRequest)
            }
            
            return User.Id(id: user.id)
        } else {
            throw Abort(.badRequest)
        }
    }
    
    func userInfo(req: Request) async throws -> User.Public {
        // Get ID from the request
        let id = req.parameters.get("id", as: UUID.self)
        
        // Find user on db
        guard let user = try await User.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "News ID not found")
        }
        
        return User.Public(userName: user.name, email: user.email, image: user.image)
    }
}
