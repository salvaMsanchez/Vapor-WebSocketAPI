//
//  File.swift
//  
//
//  Created by Salva Moreno on 18/3/24.
//

import Vapor
import Fluent

struct ModelsMigration_v0: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database
            .schema(User.schema)
            .id()
            .field("created_at", .string)
            .field("image", .string)
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .unique(on: "email")
            .create()
        
        try await database
            .schema(Message.schema)
            .id()
            .field("type", .string, .required)
            .field("message", .string, .required)
            .field("aired_at", .string)
            .field("user_id", .uuid, .required, .references(User.schema, "id"))
            .create()
        
//        try await database
//            .schema(UserMessagePivot.schema)
//            .id()
//            .field("user_id", .uuid, .required, .references(User.schema, "id"))
//            .field("message_id", .uuid, .required, .references(Message.schema, "id"))
//            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
        try await database.schema(Message.schema).delete()
//        try await database.schema(UserMessagePivot.schema).delete()
    }
}
