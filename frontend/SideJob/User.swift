//
//  User.swift
//  SideJob
//
//  Created by Lars Jensen on 10/26/23.
//

import Foundation

class UserInfo: ObservableObject {
    var name: String
    var email: String
    var password: String
    var userID: Int
    var jobsPostedIDs: [Int]
    var jobsWorkedIDs: [Int]
    
    init() {
        self.name = ""
        self.email = ""
        self.password = ""
        self.userID = -1
        self.jobsPostedIDs = [Int]()
        self.jobsWorkedIDs = [Int]()
    }
}

class UserTokens: Codable, ObservableObject {
    @Published var accessToken: Int
    @Published var refreshToken: Int
    
    init() {
        accessToken = -1
        refreshToken = -1
    }
    
    enum CodingKeys: Int, CodingKey {
        case accessToken
        case refreshToken
        // Add other coding keys as needed
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(Int.self, forKey: .accessToken)
        refreshToken = try container.decode(Int.self, forKey: .refreshToken)
        // Decode other properties if any
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(refreshToken, forKey: .refreshToken)
        // Encode other properties if any
    }

}
