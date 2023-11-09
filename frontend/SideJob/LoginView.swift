//
//  LoginView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    var body: some View {
        Text("Login to your Account:")
        VStack(spacing: 100) {
            HStack { Text("Username"); TextField("username", text: $username) }
            HStack { Text("Password"); TextField("password", text: $password) }
            Button("Log In", action: attemptLogin).buttonStyle(.bordered)
        }.padding()
    }
}

func attemptLogin(){
    // where we check with backed to see if user is valid
    // if it works, set logged in to true
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
