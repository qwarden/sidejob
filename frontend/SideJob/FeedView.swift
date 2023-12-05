//
//  FeedView.swift
//  SideJob
//
//  Created by Quimby Warden on 10/4/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var jobService = JobService.shared
    @EnvironmentObject private var location: LocationManager
    
    var body: some View {
        NavigationView {
            VStack {
                JobListView()
            }
            .onAppear {
                jobService.fetchJobs()
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
