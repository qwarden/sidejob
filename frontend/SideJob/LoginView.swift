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
    
    @State private var loggedIn = false
    
    @EnvironmentObject var userTokens: UserTokens
    
    var body: some View {
        if (!loggedIn) {
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
        else {
            AppView().navigationBarBackButtonHidden()
        }
    }
    
    func attemptLogin(){
        if (frontEndChecks()) {
            // where we check with backed to see if user is valid
            // if it works, set logged in to true
            // persist tokens
            userTokens.accessToken = 2
            userTokens.refreshToken = 2
            saveChanges()
            loggedIn = true
        }
    }
    
    func saveChanges() {
        
        let itemArchiveURL: URL = {
            let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentDirectory = documentDirectories.first!
            return documentDirectory.appendingPathComponent("tokens.json")
        }()
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(userTokens)
            try jsonData.write(to: itemArchiveURL, options: [.atomicWrite])
        }
        catch let error {
            print("error saving to json: \(error)")
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


struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
