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
        routes.get("messages", use: allMessages)
        routes.post("upload", use: upload)
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
        
        let imageData = Data(byteBuffer.readableBytesView)
        
        let directory = DirectoryConfiguration.detect()
        let publicDirectory = directory.workingDirectory + "Public/"
        
        let imageName = UUID().uuidString + ".jpg"
        
        let fullImagePath = publicDirectory + imageName
        
        FileManager.default.createFile(atPath: fullImagePath, contents: imageData, attributes: nil)
        
        let publicImagePath = fullImagePath.components(separatedBy: "Public")[1]
        
        return publicImagePath
    }
}
