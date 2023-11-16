//
//  SideJobApp.swift
//  SideJob
//
//  Created by Quimby Warden on 10/4/23.
//

import SwiftUI

@main
struct SideJobApp: App {
    @StateObject private var userTokens = UserTokens()
    
    var body: some Scene {
        WindowGroup {
            WelcomeView().environmentObject(UserTokens())
        }
    }
}
