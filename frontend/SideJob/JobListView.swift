//
//  JobListView.swift
//  SideJob
//
//  Created by India Davis on 11/9/23.
//

import SwiftUI
import CoreLocation


struct JobListView: View {
    // Using ObservedObject to observe changes in the shared JobService instance
    @ObservedObject var jobService = JobService.shared
    @State private var showingPostView = false
    @EnvironmentObject private var locationObject: LocationManager
    @State var radius = 100
    @State var zipCode = ""

    var body: some View {
        VStack {
            NavigationView {
                // Add a button at the top to transition to the Filter View
                VStack {
                    Spacer()
                    NavigationLink(destination: FilterView(zipCode: $zipCode, radius: $radius)) {
                        Text("Filter Based on Location")
                    }
                    Spacer()
                    
                    ZStack(alignment: .bottomTrailing) {
                        // List of jobs, each represented by JobView
                        List(filteredJobs) { job in
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
    }
    
    // variable that holds the filtered jobs
    var filteredJobs: [Job] {
        guard !zipCode.isEmpty else {
            return jobService.jobs
        }

        var filteredJobs: [Job] = []
        let dispatchGroup = DispatchGroup()
        
        locationObject.getLocationFromZipCode(from: zipCode) { zipCodeLocation in
            guard let userLocation = zipCodeLocation else {
                // Handle the case where the location could not be determined from the zip code
                dispatchGroup.notify(queue: .main) {
                    // The asynchronous operations are completed
                    // Now you can use the filteredJobs array
                    print("Filtered Jobs: \(filteredJobs)")
                }
                return
            }
            
            for job in jobService.jobs {
                dispatchGroup.enter()
                
                locationObject.getLocationFromZipCode(from: job.location) { location in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    if let location = location {
                        let distance = userLocation.distance(from: location)
                        let radius: CLLocationDistance = CLLocationDistance(miles2meters(miles: Double(self.radius))) // 10 kilometers
                        
                        if distance <= radius {
                            filteredJobs.append(job)
                        }
                    } else {
                        print("Failed to get location for the zip code.")
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                // The asynchronous operations are completed
                // Now you can use the filteredJobs array
                print("Filtered Jobs: \(filteredJobs)")
            }
        }

        // This is a temporary return value; the actual filteredJobs will be available after the completion handler is called
        return jobService.jobs
    }
    
    func miles2meters(miles: Double) -> Double{
        return (miles * 1609.34)
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
