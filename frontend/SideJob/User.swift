//
//  User.swift
//  SideJob
//
//  Created by Lars Jensen on 10/26/23.
//

import Foundation

struct User: Codable {
    let ID: Int
    let CreatedAt, UpdatedAt: Date?
    var name: String
    var email: String
    var password: String
    var about: String
    
    init() {
        self.ID = 0
        self.CreatedAt = nil
        self.UpdatedAt = nil
        self.name = ""
        self.email = ""
        self.password = ""
        self.about = ""
    }
}

struct UserResponse: Codable {
    let id: Int
    let created_at, updated_at: Date?
    var name: String
    var email: String
    var about: String
    
    init() {
        self.id = 0
        self.created_at = nil
        self.updated_at = nil
        self.name = ""
        self.email = ""
        self.about = ""
    }
}
