//
//  File.swift
//  
//
//  Created by Salva Moreno on 18/3/24.
//

import Vapor
import Fluent

#warning("Quizá sea bueno cambiar y crear PhotoController para tener agrupados los endpoints de photo/upload y photo/profile")
enum PhotoType: String {
    case profile
    case wall
}

struct MessagesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
            builder.get("messages", use: allMessages)
            builder.post("upload", use: upload)
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
    
    func upload(req: Request) async throws -> String {
        guard let byteBuffer = req.body.data else {
            throw Abort(.badRequest)
        }
        
        guard let photoType: String = req.query["type"] else {
            throw Abort(.badRequest)
        }
        
        switch photoType {
            case PhotoType.profile.rawValue:
                let imageData = Data(byteBuffer.readableBytesView)
                
                let directory = DirectoryConfiguration.detect()
                let publicDirectory = directory.workingDirectory + "Public/Profile/"
                
                let imageName = UUID().uuidString + ".jpg"
                
                let fullImagePath = publicDirectory + imageName
                
                FileManager.default.createFile(atPath: fullImagePath, contents: imageData, attributes: nil)
                
                let publicImagePath = fullImagePath.components(separatedBy: "Public")[1]
                
                return publicImagePath
            case PhotoType.wall.rawValue:
                let imageData = Data(byteBuffer.readableBytesView)
                
                let directory = DirectoryConfiguration.detect()
                let publicDirectory = directory.workingDirectory + "Public/Wall/"
                
                let imageName = UUID().uuidString + ".jpg"
                
                let fullImagePath = publicDirectory + imageName
                
                FileManager.default.createFile(atPath: fullImagePath, contents: imageData, attributes: nil)
                
                let publicImagePath = fullImagePath.components(separatedBy: "Public")[1]
                
                return publicImagePath
            default:
                return ""
        }
    }
}
