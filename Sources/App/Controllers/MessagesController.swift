//
//  File.swift
//  
//
//  Created by Salva Moreno on 18/3/24.
//

import Vapor
import Fluent

struct MessagesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
            builder.get("messages", use: allMessages)
        }
    }
}

extension MessagesController {
    func allMessages(req: Request) async throws -> [Message] {
        try await Message
            .query(on: req.db)
            .sort(\.$airedAt, .descending)
            .all()
    }
}
