//
//  FeedView.swift
//  SideJob
//
//  Created by Quimby Warden on 10/4/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var jobViewModel = JobViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                JobListView(jobListViewModel: jobViewModel)
            }
            .navigationBarTitle("Sidejobs")
            .onAppear {
                jobViewModel.fetchJobs()
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
