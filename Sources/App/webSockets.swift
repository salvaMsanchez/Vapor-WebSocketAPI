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
        if !webSocketController.checkConnection(ws) {
            webSocketController.addConnection(ws)
            print("LA CONEXIÓN FUE AÑADIDA")
        }
        
        webSocketController.onUpdated(ws, on: req)
        
        webSocketController.onClosed(ws, on: req)
    }
}
