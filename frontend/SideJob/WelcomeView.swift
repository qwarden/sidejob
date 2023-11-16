//
//  WelcomeView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/18/23.
//

import SwiftUI

struct WelcomeView: View {
    @State private var loggedIn = false
    
    init(loggedIn: Bool = false) {
        self.loggedIn = checkLoggedIn()
    }
    
    var body: some View {
        //if we haven't already logged in, we show welcome screen.
        if !(loggedIn){
            LoginAccountNavigation()
        }
        else {
            FeedView()
        }
    }
    
    func checkLoggedIn() -> Bool {
        //here we implement checking the persistence to see if user has already logged in, if so we get that login info and update the user environment object
        
        // first check authentication token
            // if it works, return true
        // if it doesn't validate
            // check the refresh token
            // if the refresh token validates
                // check new authentication token
            // if it doesn't validate
                // return false
        
        // persist the authentication and refresh tokens
        
        return false // default return false and make them login again
    }
    
    
}

struct LoginAccountNavigation: View {
    var body: some View {
        NavigationStack {
            Spacer()
            Text("SideJob").font(.system(size: 48, weight: .bold, design: .default))
                .foregroundColor(Color(.systemBlue)).padding(100)
            Spacer()
            NavigationLink(destination: LoginView()) {
                Text("Login").font(.largeTitle)
            }.padding()
            NavigationLink(destination: CreateAccountView()) {
                Text("Create Account").font(.largeTitle)
            }
            Spacer()
        }
    }
}

#Preview {
    WelcomeView()
}
