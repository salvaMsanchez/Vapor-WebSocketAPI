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
    
    @Field(key: "username")
    var userName: String
    
    @Field(key: "type")
    var type: MessageType.RawValue
    
    @Field(key: "message")
    var message: String
    
    @Timestamp(key: "aired_at", on: .none, format: .iso8601)
    var airedAt: Date?
    
    // Inits
    init() {}
    
    init(id: UUID? = nil, userName: String, type: MessageType.RawValue, message: String, airedAt: Date?) {
        self.id = id
        self.userName = userName
        self.type = type
        self.message = message
        self.airedAt = airedAt
    }
}
