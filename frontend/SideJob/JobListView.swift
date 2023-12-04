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
    @EnvironmentObject private var locationObject: LocationManager

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
    
    var filteredJobs: [Job] {
        guard let userLocation = locationObject.location else {
            return jobService.jobs
        }

        return jobService.jobs.filter { job in
            // here we need to get longitude and latitude from zip code
            let
            let jobLocation = CLLocation(latitude: job.latitude, longitude: job.longitude)
            let distance = userLocation.distance(from: jobLocation) // distance in meters

            // You can adjust the radius (in meters) based on your requirements
            let radius: CLLocationDistance = 10000 // 10 kilometers

            return distance <= radius
        }
    }
    
    func getLongAndLatFromZip(String
    
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
