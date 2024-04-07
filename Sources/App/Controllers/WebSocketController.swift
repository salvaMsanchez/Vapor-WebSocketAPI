//
//  File.swift
//  
//
//  Created by Salva Moreno on 15/3/24.
//

import Vapor
import NIO

final class WebSocketController {
    private var connections = [WebSocket]()

    func addConnection(_ ws: WebSocket) {
        connections.append(ws)
    }

    func removeConnection(_ ws: WebSocket) {
        connections.removeAll { $0 === ws }
    }
    
    func checkConnection(_ ws: WebSocket) -> Bool {
        for connection in connections {
            if connection === ws {
                return true
            }
        }
        return false
    }

    func sendToAll(_ data: ByteBuffer) {
        for connection in connections {
            connection.send(data)
        }
    }
}

extension WebSocketController {
    func onUpdated(_ ws: WebSocket, on req: Request) {
        ws.onBinary { ws, byteBuffer in
            do {
                let decoder = JSONDecoder()
                let publicMessage = try decoder.decode(Message.Public.self, from: byteBuffer)
//                print("AQUÍ LLEGO ------ \(publicMessage.user.email)")
                
//                let message: Message = .init(id: publicMessage.id, type: publicMessage.type, message: publicMessage.message, airedAt: publicMessage.airedAt)
//                let user: User = .init(image: publicMessage.user.image, name: publicMessage.user.name, email: publicMessage.user.email, password: "")

                // Save on DB
//                try await message.create(on: req.db)
                print("AQUÍ LLEGO ------")
                
//                try await message.$users.attach([user], on: req.db)

                self.sendToAll(byteBuffer)
            } catch {
                print(error)
            }
        }
    }
    
    func onClosed(_ ws: WebSocket, on req: Request) {
        ws.onClose.whenComplete { [weak self] result in
            switch result {
                case .success():
                    print("---")
                    print("LA CONEXIÓN SE HA CERRADO")
                    self?.removeConnection(ws)
                case .failure(let error):
                    print("---")
                    print("LA CONEXIÓN NO SE HA CERRADO. ERROR: \(error)")
            }
        }
    }
}
