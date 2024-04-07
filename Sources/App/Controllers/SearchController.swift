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
        routes.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
            builder.get("search", use: search)
        }
    }
}

extension SearchController {
    func search(req: Request) async throws -> [Message] {
        guard let searchText: String = req.query["search"] else {
            throw Abort(.badRequest)
        }
        
        let spaceStrippedSearchText = searchText.trimmingCharacters(in: .whitespaces)
        
        let smartSearchMatcher = SmartSearchMatcher(searchString: spaceStrippedSearchText)
        
        let allMessages: [Message] = try await Message.query(on: req.db).sort(\.$airedAt, .descending).all()
        
        let matchedMessages: [Message] = allMessages.filter { smartSearchMatcher.matches($0.message) }
//        let matchedProfiles: [Message] = allMessages.filter { smartSearchMatcher.matches($0.userName) }
        
//        return matchedMessages + matchedProfiles
        return matchedMessages
    }
}

struct SmartSearchMatcher {
    public init(searchString: String) {
        searchTokens = searchString.split(whereSeparator: { $0.isWhitespace} ).sorted { $0.count > $1.count }
    }
    
    func matches(_ candidateString: String) -> Bool {
        guard !searchTokens.isEmpty else { return true }
        
        var candidateStringTokens = candidateString.split(whereSeparator: { $0.isWhitespace })
        
        for searchToken in searchTokens {
            var matchedSearchToken = false
            
            for (candidateStringTokenIndex, candidateStringToken) in candidateStringTokens.enumerated() {
                if let range = candidateStringToken.range(of: searchToken, options: [.caseInsensitive, .diacriticInsensitive]),
                   range.lowerBound == candidateStringToken.startIndex {
                    matchedSearchToken = true
                    candidateStringTokens.remove(at: candidateStringTokenIndex)
                    break
                }
            }
            
            guard matchedSearchToken else { return false }
        }
        
        return true
    }
    
    private(set) var searchTokens: [String.SubSequence]
}
