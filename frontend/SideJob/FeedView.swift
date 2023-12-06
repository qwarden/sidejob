//
//  FeedView.swift
//  SideJob
//
//  Created by Quimby Warden on 10/4/23.
//

import SwiftUI

struct FeedView: View {
    @State private var showingPostView = false
    @EnvironmentObject private var client: Client
    @EnvironmentObject private var locationObject: LocationManager
    @State var radius = 100
    @State var zipCode = ""

    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(destination: FilterView(zipCode: $zipCode, radius: $radius)) {
                    Text("Filter Based on Location")
                }
                Spacer()
                
                JobListView(endpoint: "/jobs/", zipCode: zipCode, radius: radius)

                FloatingActionButton(action: {
                    self.showingPostView = true
                })
            }
            .navigationBarTitle("Jobs")
            .sheet(isPresented: $showingPostView) {
                PostView()
            }
        }
    }
    
    struct FloatingActionButton: View {
        var action: () -> Void

        var body: some View {
            Button(action: action) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding()
            }
        }
    }
    
    

}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView().environmentObject(Client())
    }
}
