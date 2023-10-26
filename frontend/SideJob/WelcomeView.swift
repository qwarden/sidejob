//
//  WelcomeView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/18/23.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            LoginAccountNavigation()
        }
    }
}

struct LoginAccountNavigation: View {
    var body: some View {
        Text("SideJob").font(.system(size: 48, weight: .bold, design: .default))
            .foregroundColor(Color(.systemBlue)).padding(100)
        NavigationStack {
            NavigationLink(destination: LoginView()) {
                Text("Login").font(.largeTitle)
            }.padding()
            NavigationLink(destination: CreateAccountView()) {
                Text("Create Account").font(.largeTitle)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
