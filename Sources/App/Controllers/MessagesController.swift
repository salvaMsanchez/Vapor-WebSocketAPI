//
//  File.swift
//  
//
//  Created by Salva Moreno on 18/3/24.
//

import Foundation
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
    func allMessages(req: Request) async throws -> [Message.Public] {
        let messages: [Message] = try await Message
            .query(on: req.db)
            .sort(\.$airedAt, .descending)
            .all()

        let publicMessages: [Message.Public] = try messages.map { message in
            guard let id = message.id,
                  let airedAt = message.airedAt
            else {
                throw Abort(.expectationFailed, reason: "Id, date or userId message not found")
            }
            return Message.Public(id: id, type: message.type, message: message.message, airedAt: airedAt, user: message.$user.id)
        }
        
        return publicMessages
    }
}
