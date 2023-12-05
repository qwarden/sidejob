//
//  WelcomeView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/18/23.
//

import SwiftUI

struct WelcomeView: View {
    @State private var loggedIn = false
    
    var body: some View {
        //if we haven't already logged in, we show welcome screen.
        Group {
            if !(loggedIn){
                LoginAccountNavigation()
            }
            else {
                AppView()
            }
        }.onAppear {
            // Perform the check and update state here
            loggedIn = checkLoggedIn()
        }
    }
    
    func checkLoggedIn() -> Bool {
        //here we implement checking the persistence to see if user has already logged in, if so we get that login info and update the user environment object
    }
    
}

struct LoginAccountNavigation: View {
    //@EnvironmentObject var userTokens: UserTokens
    
    var body: some View {
        NavigationStack {
            Spacer()
            //Text("\(userTokens.accessToken)")
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

struct WelcomeView_Preview: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
