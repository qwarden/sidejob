//
//  MyListingsView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI



struct ListingsView: View {
       let user: UserInfo

       init(user: UserInfo) {
           self.user = user
       }
    
    
    // Using ObservedObject to observe changes in the shared JobService instance
    @State private var showingPostView = false
    
    var body: some View {
      NavigationView {
            Text(user.name)
            ZStack(alignment: .bottomTrailing) {
                // List of jobs, each represented by JobView
                
            }
      
            // Present the PostView as a sheet
            .sheet(isPresented: $showingPostView) {
                PostView()
            }
        }
    }
}
