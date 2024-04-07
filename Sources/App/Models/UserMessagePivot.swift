//
//  File.swift
//  
//
//  Created by Salva Moreno on 6/4/24.
//

//import Vapor
//import Fluent
//
//final class UserMessagePivot: Model {
//    // Schema
//    static var schema: String = "user+message"
//    
//    // Properties
//    @ID(key: .id)
//    var id: UUID?
//    
//    @Parent(key: "user_id")
//    var user: User
//    
//    @Parent(key: "message_id")
//    var message: Message
//    
//    // Inits
//    init() {}
//    
//    init(id: UUID? = nil, user: User, message: Message) throws {
//        self.id = id
//        self.$user.id = try user.requireID()
//        self.$message.id = try message.requireID()
//    }
//}
