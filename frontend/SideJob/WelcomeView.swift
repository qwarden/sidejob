//
//  WelcomeView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/18/23.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        Text("Welcome to SideJob!")
        NavigationDemo()
    }
}

struct NavigationDemo: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination: LoginView()) {
                Text("Login").font(.largeTitle) }
            NavigationLink(destination: CreateAccountView()) {
                Text("Create Account").font(.largeTitle)
            }
        }
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
    WelcomeView()
}
