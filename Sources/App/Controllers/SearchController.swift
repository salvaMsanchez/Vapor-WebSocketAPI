//
//  File.swift
//  
//
//  Created by Salva Moreno on 27/3/24.
//

import Vapor
import Fluent

struct SearchController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("search", use: search)
    }
}

extension SearchController {
    func search(req: Request) async throws -> String {
        guard let searchText: String = req.query["search"] else {
            throw Abort(.badRequest)
        }
        
        let spaceStrippedSearchText = searchText.trimmingCharacters(in: .whitespaces)
        
        let smartSearchMatcher = SmartSearchMatcher(searchString: spaceStrippedSearchText)
        
        return ""
    }
}

struct SmartSearchMatcher {
    public init(searchString: String) {
        searchTokens = searchString.split(whereSeparator: { $0.isWhitespace} ).sorted { $0.count > $1.count }
    }
    
    func matches(_ candidateString: String) -> Bool {
        // TODO
        
        return true
    }
    
    private(set) var searchTokens: [String.SubSequence]
}
