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
    @State private var creatingAccount = false
    @EnvironmentObject var client: Client
    
    struct AccountInfo: Codable {
        let email: String
        let password: String
        let name: String
        let about: String
    }
    
    var body: some View {
        if creatingAccount {
            ProgressView("Creating Account...")
        }
        else if (!accountCreated) {
            Text("Create your Account:").font(.system(size: 24, weight: .bold, design: .default)).foregroundColor(Color(.systemBlue)).padding()
            VStack(spacing: 25) {
                HStack { Text("Name"); TextField("name", text: $name).autocapitalization(.none) }
                //error messages go here
                if (nameErrorMessages != "") {
                    Text(nameErrorMessages).foregroundColor(Color.red)
                }
                HStack { Text("Email"); TextField("email", text: $email).autocapitalization(.none) }
                if (emailErrorMessages != "") {
                    Text(emailErrorMessages).foregroundColor(Color.red)
                }
                HStack { Text("Password"); SecureField("password", text: $password).autocapitalization(.none) }
                if (passwordErrorMessageEmpty != "") {
                    Text(passwordErrorMessageEmpty).foregroundColor(Color.red)
                }
                HStack { Text("Confirm Password"); SecureField("password", text: $passwordConfirm).autocapitalization(.none) }
                if (passwordErrorMessageMatch != "") {
                    Text(passwordErrorMessageMatch).foregroundColor(Color.red)
                }
                Button("Create Account", action: attemptCreateAccount).buttonStyle(.bordered)
                
                //error messages go here
                if (accountCreationErrorMessages != ""){
                    Text(accountCreationErrorMessages).foregroundColor(Color.red)
                }
                
            }.padding()
        }
        else {
            AppView().navigationBarBackButtonHidden()
        }
    }
    
    func attemptCreateAccount(){
        if (frontEndChecks()) {
            creatingAccount = true
            let lowercaseEmail = self.email.lowercased()
            let credentials = AccountInfo(email: lowercaseEmail, password: self.password, name: self.name, about: "")
            
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(credentials)

                // Convert Data to String if needed
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON String: \(jsonString)")
                }
                
                client.fetch(verb: "POST", endpoint: "auth/register", auth: false, data: jsonData) {result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            do {
                                let decoder = JSONDecoder()
                                let tokens = try decoder.decode(Tokens.self, from:data)
                                client.saveTokens(tokens)
                                client.loggedIn = true
                                self.accountCreated = true
                                creatingAccount = false
                            }
                            catch {
                                creatingAccount = false
                                accountCreationErrorMessages = "User with that Email already exists."
                            }
                        case .failure(let error):
                            print("Error during account creation: \(error)")
                            accountCreationErrorMessages = "User with that Email already exists."
                            self.accountCreated = false
                            creatingAccount = false
                        }
                    }
                 }

                // Now you can pass jsonData to your client.fetch method
            } catch {
                creatingAccount = false
                print("Error encoding credentials: \(error)")
                accountCreationErrorMessages = "Account Creation Invalid"
            }

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

//struct CreateAccount_Preview: PreviewProvider {
//    static var previews: some View {
//        CreateAccountView()
//    }
//}
