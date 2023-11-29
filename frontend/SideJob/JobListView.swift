//
//  JobListView.swift
//  SideJob
//
//  Created by India Davis on 11/9/23.
//

import SwiftUI


struct JobListView: View {
    // Using ObservedObject to observe changes in the shared JobService instance
    @ObservedObject var jobService = JobService.shared
    @State private var showingPostView = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                // List of jobs, each represented by JobView
                List(jobService.jobs) { job in
                    JobView(job: job)
                }
                .navigationBarTitle("Jobs")
                // Fetch jobs when the view appears
                .onAppear {
                    jobService.fetchJobs()
                }

                // Floating action button to show the PostView
                FloatingActionButton(action: {
                    self.showingPostView = true
                })
            }
            // Present the PostView as a sheet
            .sheet(isPresented: $showingPostView) {
                PostView()
            }
        }
    }
}

// NewJob button
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


struct JobListView_Preview: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
