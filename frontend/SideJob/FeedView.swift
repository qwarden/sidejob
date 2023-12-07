//
//  FeedView.swift
//  SideJob
//
//  Created by Quimby Warden on 10/4/23.
//

import SwiftUI

struct FeedView: View {
    @State private var showingPostView = false
    @State private var showingFilterView = false
    @State var filteringByLocation = false
    @EnvironmentObject private var client: Client
    @EnvironmentObject private var locationObject: LocationManager
    @State private var refreshID = UUID()
    @State var userZipCode = ""
    @State var radius = 100
    @State var isFiltering = false
    
    var body: some View {
        NavigationView {
            VStack {
                JobListView(endpoint: "/jobs/", filteringByLocation: $filteringByLocation, refreshID: refreshID,
                            radius: $radius, userZipCode: $userZipCode, isFiltering: $isFiltering)
                    .refreshable {
                        self.refreshID = UUID()
                    }
                
                HStack {
                    FloatingActionButtonFilter(action: {
                        self.showingFilterView = true
                    })
                    FloatingActionButtonPost(action: {
                        self.showingPostView = true
                    })
                }
                
            }
            .navigationBarTitle("Jobs")
            .sheet(isPresented: $showingPostView) {
                PostView()
            }
            .sheet(isPresented: $showingFilterView) {
                FilterView(filteringByLocation: $filteringByLocation, userZipCode: $userZipCode, radius: $radius, isFiltering: $isFiltering)
            }
        }
    }
    
    struct FloatingActionButtonPost: View {
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
    
    struct FloatingActionButtonFilter: View {
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text("Filter")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
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
