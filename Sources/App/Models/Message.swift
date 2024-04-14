//
//  File.swift
//  
//
//  Created by Salva Moreno on 15/3/24.
//

import Vapor
import Fluent

enum MessageType: String, Decodable {
    case TEXT
    case IMAGE
}

final class Message: Model, Content, Decodable {
    // Schema
    static var schema = "messages"
    
    // Properties
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "type")
    var type: MessageType.RawValue
    
    @Field(key: "message")
    var message: String
    
    @Timestamp(key: "aired_at", on: .none, format: .iso8601)
    var airedAt: Date?
    
    @Parent(key: "user_id")
    var user: User
    
    // Inits
    init() {}
    
    init(id: UUID? = nil, type: MessageType.RawValue, message: String, airedAt: Date?, userID: User.IDValue) {
        self.id = id
        self.type = type
        self.message = message
        self.airedAt = airedAt
        self.$user.id = userID
    }
}

extension Message {
    struct Public: Content {
        let id: UUID
        let type: MessageType.RawValue
        let message: String
        let airedAt: Date?
        let user: User.IDValue
    }
}
