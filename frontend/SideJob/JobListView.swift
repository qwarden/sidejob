//
//  JobListView.swift
//  SideJob
//
//  Created by India Davis on 11/9/23.
//

import SwiftUI


struct JobListView: View {
    @ObservedObject var jobListViewModel: JobViewModel

    var body: some View {
        List(jobListViewModel.jobs) { job in
            NavigationLink(destination: DetailsView(job: job)) {
                JobView(job: job)
            }
            .buttonStyle(PlainButtonStyle())
            .listRowInsets(EdgeInsets())
        }
        .onAppear {
            print("JobListView appeared")
            jobListViewModel.fetchJobs()
        }
    }
}


struct JobListView_Preview: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
