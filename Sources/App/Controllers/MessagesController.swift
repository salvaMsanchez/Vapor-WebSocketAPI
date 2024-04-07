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
        
        return try await withThrowingTaskGroup(of: Message.Public?.self, body: { group in
            var publicMessages: [Message.Public] = []
            publicMessages.reserveCapacity(messages.count)
            
            for message in messages {
                group.addTask {
                    try? await loadMessages(req: req, message: message)
                }
            }
            
            for try await message in group {
                if let message {
                    let publicMessage: Message.Public = .init(id: message.id, type: message.type, message: message.message, airedAt: message.airedAt, user: message.user)
                    publicMessages.append(publicMessage)
                }
            }
            
            return publicMessages
        })
    }
    
    private func loadMessages(req: Request, message: Message) async throws -> Message.Public {
//        do {
//            try await message.$users.load(on: req.db)
//
//            let userPublic: User.Public = .init(image: message.users[0].image, name: message.users[0].name, email: message.users[0].email)
//
//            guard let messageId = message.id else {
//                return Message.Public(id: UUID(), type: message.type, message: message.message, airedAt: message.airedAt, user: userPublic)
//            }
//
//            return Message.Public(id: messageId, type: message.type, message: message.message, airedAt: message.airedAt, user: userPublic)
//        } catch let error {
//            throw error
//        }
        
        let publicMessage: Message.Public = .init(id: UUID(), type: "", message: "", airedAt: nil, user: UUID())
        return publicMessage
    }
}
