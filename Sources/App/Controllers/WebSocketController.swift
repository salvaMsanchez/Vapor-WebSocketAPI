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
    func webSocketUpdated(_ ws: WebSocket, on req: Request) {
        ws.onBinary { ws, byteBuffer in
            // Handle incoming binary data
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(Message.self, from: byteBuffer)
//                print("---")
//                print("ID: \(decodedData.id)")
//                print("USERNAME: \(decodedData.userName)")
//                print("TYPE: \(decodedData.type)")
//                print("MESSAGE: \(decodedData.message)")
//                print("TIMESTAMP: \(decodedData.airedAt)")
//                print("---")
                
                // Save on DB
                try await decodedData.create(on: req.db)
                
                // Send the received data back to the client
                self.sendToAll(byteBuffer)
            } catch {
                print("Error al convertir desde Data: \(error)")
            }
        }
    }
}