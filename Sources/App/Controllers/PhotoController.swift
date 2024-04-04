//
//  File.swift
//  
//
//  Created by Salva Moreno on 4/4/24.
//

import Vapor
import Fluent

enum PhotoType: String {
    case profile
    case wall
}

struct PhotoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("photo") { builder in
            builder.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
                builder.post("upload", use: upload)
                builder.post("profile", use: saveProfilePhoto)
            }
        }
    }
}

extension PhotoController {
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
    
    func saveProfilePhoto(req: Request) async throws -> String {
        // Decode photo data
        let photoData = try req.content.decode(Photo.self)
        
        // Find user on db
        guard let user = try await User
            .query(on: req.db)
            .filter(\.$email == photoData.email)
            .first() else {
            throw Abort(.badRequest)
        }
        
        user.image = photoData.image
        
        try await user.update(on: req.db)
        
        return "Photo saved successfully"
    }
}
