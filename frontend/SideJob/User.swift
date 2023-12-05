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
