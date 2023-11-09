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
    
    @State private var emailErrorMessage = ""
    @State private var passwordErrorMessage = ""
    @State private var loginErrorMessage = ""

    
    var body: some View {
        Text("Login to your Account:").font(.system(size: 24, weight: .bold, design: .default)).foregroundColor(Color(.systemBlue)).padding()
        VStack(spacing: 25) {
            HStack { Text("Email"); TextField("email", text: $email) }
            if (emailErrorMessage != "") {
                Text(emailErrorMessage).foregroundColor(Color.red)
            }
            HStack { Text("Password"); SecureField("password", text: $password) }
            if (passwordErrorMessage != "") {
                Text(passwordErrorMessage).foregroundColor(Color.red)
            }
            Button("Log In", action: attemptLogin).buttonStyle(.bordered)
            if (loginErrorMessage != "") {
                Text(loginErrorMessage).foregroundColor(Color.red)
            }
            
        }.padding()
    }
    
    func attemptLogin(){
        if (frontEndChecks()) {
            // where we check with backed to see if user is valid
            // if it works, set logged in to true
        }
    }
    
    func frontEndChecks() -> Bool {
        var frontendChecksPassed = true
        
        // reset error messages
        emailErrorMessage = ""
        passwordErrorMessage = ""
        loginErrorMessage = ""
        
        // email checks
        if (email == "") {
            emailErrorMessage = "Email cannot be empty."
            frontendChecksPassed = false
        }
        else if (!email.contains("@")) {
            emailErrorMessage = "Invalid Email. Must contain '@' character."
            frontendChecksPassed = false
        }
        
        // password checks
        if (password == "") {
            passwordErrorMessage = "Password cannot be empty."
            frontendChecksPassed = false
        }
        
        return frontendChecksPassed
    }
}

#Preview {
    LoginView()
}
