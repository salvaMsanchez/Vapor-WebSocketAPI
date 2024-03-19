//
//  File.swift
//  
//
//  Created by Salva Moreno on 14/3/24.
//

import Vapor

func webSockets(_ app: Application) throws {
    
    let webSocketController = WebSocketController()
    
    app.webSocket("wall") { req, ws in
        print("WebSocket - WALL")
        
        if !webSocketController.checkConnection(ws) {
            webSocketController.addConnection(ws)
            print("LA CONEXIÓN FUE AÑADIDA")
        }
        
        webSocketController.webSocketUpdated(ws, on: req)
    }
}
