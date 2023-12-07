//
//  MyListingsView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI



struct ListingsView: View {
   let user: User

   init(user: User) {
       self.user = user
   }

    @State private var showingPostView = false

    var body: some View {
        NavigationView {
            VStack {
                JobListView(endpoint: "/my/jobs", filteringByLocation: .constant(false))
            }
        }
        .navigationBarTitle("My Listings", displayMode: .inline)
    }
}
