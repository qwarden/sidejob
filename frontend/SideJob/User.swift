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
