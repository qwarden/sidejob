//
//  LoginView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI

struct CreateAccountView: View {
    //User variables
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    
    // Error messages
    @State private var nameErrorMessages = ""
    @State private var emailErrorMessages = ""
    @State private var passwordErrorMessageEmpty = ""
    @State private var passwordErrorMessageMatch = ""
    @State private var accountCreationErrorMessages = ""
    
    @State private var accountCreated = false
    @EnvironmentObject var userTokens: UserTokens
    
    var body: some View {
        if (!accountCreated) {
            Text("Create your Account:").font(.system(size: 24, weight: .bold, design: .default)).foregroundColor(Color(.systemBlue)).padding()
            VStack(spacing: 25) {
                HStack { Text("Name"); TextField("name", text: $name) }
                //error messages go here
                if (nameErrorMessages != "") {
                    Text(nameErrorMessages).foregroundColor(Color.red)
                }
                HStack { Text("Email"); TextField("email", text: $email) }
                if (emailErrorMessages != "") {
                    Text(emailErrorMessages).foregroundColor(Color.red)
                }
                HStack { Text("Password"); SecureField("password", text: $password) }
                if (passwordErrorMessageEmpty != "") {
                    Text(passwordErrorMessageEmpty).foregroundColor(Color.red)
                }
                HStack { Text("Confirm Password"); SecureField("password", text: $passwordConfirm) }
                if (passwordErrorMessageMatch != "") {
                    Text(passwordErrorMessageMatch).foregroundColor(Color.red)
                }
                Button("Create Account", action: attemptCreateAccount).buttonStyle(.bordered)
                
                //error messages go here
                if (accountCreationErrorMessages != ""){
                    Text(accountCreationErrorMessages)
                }
                
            }.padding()
        }
        else {
            FeedView()
        }
    }
    
    func attemptCreateAccount(){
        if (frontEndChecks()) {
            // where we check with backend to see if user creation is valid
            if (true) {
                // update the observable object for the user
                userTokens.accessToken = 1
                userTokens.refreshToken = 2
                saveChanges()
                accountCreated = true
            }
            else {
                accountCreationErrorMessages = "Sorry, there were issues on our side creating your account"
            }
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
        
        //reset error messages
        nameErrorMessages = ""
        emailErrorMessages = ""
        passwordErrorMessageEmpty = ""
        passwordErrorMessageMatch = ""
        accountCreationErrorMessages = ""
        
        // name check
        if (name == "") {
            nameErrorMessages = "Name cannot be empty."
            frontendChecksPassed = false
        }
        
        // email checks
        if (email == "") {
            emailErrorMessages = "Email cannot be empty."
            frontendChecksPassed = false
        }
        else if (!email.contains("@")) {
            emailErrorMessages = "Invalid Email. Must contain '@' character."
            frontendChecksPassed = false
        }
        
        // password checks
        if (password == "") {
            passwordErrorMessageEmpty = "Password cannot be empty."
            frontendChecksPassed = false
        }
        else if (password != passwordConfirm) {
            passwordErrorMessageMatch = "Passwords do not match."
            frontendChecksPassed = false
        }
        
        return frontendChecksPassed
    }
}

#Preview {
    CreateAccountView().environmentObject(UserTokens())
}
