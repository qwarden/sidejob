//
//  LoginView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var passwordErrorMessages = ""
    @State private var emailErrorMessages = ""

    
    var body: some View {
        Text("Create your Account:").font(.system(size: 24, weight: .bold, design: .default)).padding()
        VStack(spacing: 25) {
            HStack { Text("Name"); TextField("name", text: $name) }
            HStack { Text("Email"); TextField("email", text: $email) }
            HStack { Text("Password"); SecureField("password", text: $password) }
            HStack { Text("Confirm Password"); SecureField("password", text: $passwordConfirm) }
            Button("Create Account", action: attemptCreateAccount).buttonStyle(.bordered)
            
            //error messages go here
            Text(passwordErrorMessages)
            Text(emailErrorMessages)
            
        }.padding()
    }
    
    func attemptCreateAccount(){
        // first check if passwords match
        if (password != passwordConfirm) {
            passwordErrorMessages = "Passwords do not match."
        }
        else {
            passwordErrorMessages = ""
        }
        if (!email.contains("@")) {
            emailErrorMessages = "Invalid Email. Must contain '@' character."
        }
        else {
            emailErrorMessages = ""
        }
        
        // where we check with backed to see if user is valid
        // if it works, set logged in to true
    }
}

#Preview {
    CreateAccountView()
}
