//
//  File.swift
//  
//
//  Created by Salva Moreno on 30/3/24.
//

import Foundation
import Vapor
import JWT

struct Constants {
    static let accessTokenLifetime: Double = 60 * 30 // 30 min
}

enum JWTTokenType: String, Codable {
    case access
}

struct JWTToken: Content, JWTPayload, Authenticatable {
    // MARK: - Properties
    var exp: ExpirationClaim
    var iss: IssuerClaim
    var sub: SubjectClaim
    var type: JWTTokenType
    
    // MARK: - JWTPayload
    func verify(using signer: JWTKit.JWTSigner) throws {
        // Expired
        try exp.verifyNotExpired()
        
        // Validate bundle id
        guard iss.value == Environment.process.APP_BUNDLE_ID else {
            throw JWTError.claimVerificationFailure(name: "iss", reason: "Issuer is invalid")
        }
        
        // Validate subject
        guard let _ = UUID(sub.value) else {
            throw JWTError.claimVerificationFailure(name: "sub", reason: "Subject is invalid")
        }
        
        // Validate JWT type
        guard type == .access else {
            throw JWTError.claimVerificationFailure(name: "type", reason: "JWT type is invalid")
        }
    }
}

// MARK: - DTOs
extension JWTToken {
    struct Public: Content {
        let accessToken: String
    }
}

// MARK: - Auxiliar
extension JWTToken {
    static func generateToken(userID: UUID) -> JWTToken {
        let now = Date.now
        
        let expDate = now.addingTimeInterval(Constants.accessTokenLifetime)
        let bundleID = Environment.process.APP_BUNDLE_ID!
        let user = userID.uuidString
        
        let accessToken = JWTToken(exp: .init(value: expDate), iss: .init(value: bundleID), sub: .init(value: user), type: .access)
        
        return accessToken
    }
}
