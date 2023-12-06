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
    @State private var isLoading = false
    
    @EnvironmentObject var client: Client
    
    struct LoginInfo: Codable {
        let email: String
        let password: String
    }
    
    var body: some View {
        if isLoading {
            // Show loading spinner while fetching data
            ProgressView("Logging In...")
        } else if (!loggedIn) {
            Text("Login to your Account:").font(.system(size: 24, weight: .bold, design: .default)).foregroundColor(Color(.systemBlue)).padding()
            VStack(spacing: 25) {
                HStack { Text("Email"); TextField("email", text: $email).autocapitalization(.none) }
                if (emailErrorMessage != "") {
                    Text(emailErrorMessage).foregroundColor(Color.red)
                }
                HStack { Text("Password"); SecureField("password", text: $password).autocapitalization(.none) }
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
            isLoading = true
            let lowercaseEmail = self.email.lowercased()
            let credentials = LoginInfo(email: lowercaseEmail, password: self.password)
            
            do {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(credentials)

                // Convert Data to String if needed
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON String: \(jsonString)")
                }
                
                client.fetch(verb: "POST", endpoint: "auth/login", auth: false, data: jsonData) {  (result: Result<Data, NetworkError>) in
                     switch result {
                     case .success(let data):
                         do {
                             let decoder = JSONDecoder()
                             let tokens = try decoder.decode(Tokens.self, from:data)
                             client.saveTokens(tokens)
                             client.loggedIn = true
                             self.loggedIn = true
                             isLoading = false
                         }
                         catch {
                             isLoading = false
                             print("Error encoding and saving tokens.")
                         }
                     case .failure(let error):
                         print("Error during login: \(error)")
                         loginErrorMessage = "User with that Email and Password does not exist."
                         self.loggedIn = false
                         isLoading = false
                     }
                 }

                // Now you can pass jsonData to your client.fetch method
            } catch {
                print("Error encoding credentials: \(error)")
                loginErrorMessage = "Email and/or Password invalid"
            }

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


//struct LoginView_Preview: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}

