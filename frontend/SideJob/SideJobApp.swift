//
//  SideJobApp.swift
//  SideJob
//
//  Created by Quimby Warden on 10/4/23.
//

import SwiftUI

@main
struct SideJobApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView().environmentObject(UserInfo())
        }
    }
}
