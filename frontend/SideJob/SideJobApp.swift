//
//  SideJobApp.swift
//  SideJob
//
//  Created by Quimby Warden on 10/4/23.
//

import SwiftUI

@main
struct SideJobApp: App {
    
    @StateObject private var client = Client()
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            WelcomeView().environmentObject(client).environmentObject(locationManager)
                .onAppear {
                    client.initialize()
                }
        }
    }
}
