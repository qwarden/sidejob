//
//  MyListingsView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI


struct MyListingsView: View {
   let user: User

   init(user: User) {
       self.user = user
   }

    @State private var showingPostView = false
    @State private var refreshID = UUID()


    var body: some View {
        NavigationView {
            VStack {
                JobListView(endpoint: "/my/jobs", filteringByLocation: .constant(false), refreshID: refreshID)
            }
        }
        .navigationBarTitle("My Listings", displayMode: .inline)
    }
}
