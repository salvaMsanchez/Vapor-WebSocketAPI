//
//  File.swift
//  
//
//  Created by Salva Moreno on 27/3/24.
//

import Vapor
import Fluent
import Foundation

struct SearchController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("search", use: search)
    }
}

extension SearchController {
    func search(req: Request) async throws -> String {
        guard let search: String = req.query["search"] else {
            throw Abort(.badRequest)
        }
        
        
        
        return ""
    }
}
