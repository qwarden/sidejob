//
//  LoginView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


class UserInfo: ObservableObject {
    var name: String
    var email: String
    var phoneNumber: String
    var userID: Int
    var jobsPostedIDs: [Int]
    var jobsWorkedIDs: [Int]
    
    init() {
        self.name = ""
        self.email = ""
        self.phoneNumber = ""
        self.userID = -1
        self.jobsPostedIDs = [Int]()
        self.jobsWorkedIDs = [Int]()
    }
}

#Preview {
    LoginView()
}
