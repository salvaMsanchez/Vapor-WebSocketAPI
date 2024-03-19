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
            .schema(Message.schema)
            .id()
            .field("username", .string, .required)
            .field("type", .string, .required)
            .field("message", .string, .required)
            .field("aired_at", .string)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Message.schema).delete()
    }
}
