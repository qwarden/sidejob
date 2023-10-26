//
//  LoginView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        Text("Login to your Account:").font(.system(size: 24, weight: .bold, design: .default)).padding()
        VStack(spacing: 25) {
            HStack { Text("Email"); TextField("email", text: $email) }
            HStack { Text("Password"); SecureField("password", text: $password) }
            Button("Log In", action: attemptLogin).buttonStyle(.bordered)
        }.padding()
    }
}

func attemptLogin(){
    // where we check with backed to see if user is valid
    // if it works, set logged in to true
}

#Preview {
    LoginView()
}
