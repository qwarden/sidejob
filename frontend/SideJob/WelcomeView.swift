//
//  WelcomeView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/18/23.
//

import SwiftUI

struct WelcomeView: View {
    @State private var loggedIn = false
    @EnvironmentObject var userTokens: UserTokens
    
    var body: some View {
        //if we haven't already logged in, we show welcome screen.
        Group {
            if !(loggedIn){
                LoginAccountNavigation()
            }
            else {
                FeedView()
            }
        }.onAppear {
            // Perform the check and update state here
            loggedIn = checkLoggedIn()
        }
    }
    
    func checkLoggedIn() -> Bool {
        //here we implement checking the persistence to see if user has already logged in, if so we get that login info and update the user environment object
        let itemArchiveURL: URL = {
            let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentDirectory = documentDirectories.first!
            return documentDirectory.appendingPathComponent("tokens.json")
        }()
        if let uTokens = load(itemArchiveURL) {
            userTokens.accessToken = uTokens.accessToken
            userTokens.refreshToken = uTokens.refreshToken
        } // don't need an else statement as they're initialized to -1
        
        
        // first check authentication token
            // if it works, return true
        // if it doesn't validate
            // check the refresh token
            // if the refresh token validates
                // check new authentication token
            // if it doesn't validate
                // return false
        if (userTokens.accessToken == 1){
            return true
        }
        
        return false // default return false and make them login again
    }
    
    func load(_ url: URL) -> UserTokens? {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(UserTokens.self, from:data)
        } catch {
            return nil
        }
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
