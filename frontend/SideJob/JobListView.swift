//
//  JobListView.swift
//  SideJob
//
//  Created by India Davis on 11/9/23.
//

import SwiftUI
import CoreLocation


struct JobListView: View {
    @EnvironmentObject var client: Client
    @State var jobs: [Job] = []
    @State var loadError: Bool = false
    var endpoint: String

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
                        List {
                            if jobs.isEmpty && !loadError {
                                Text("Loading jobs...")
                            } else if loadError {
                                Button("Tap to retry") {
                                    fetchJobs()
                                }
                            } else {
                                ForEach(jobs) { job in
                                    JobView(job: job)
                                }
                            }
                            .navigationBarTitle("Jobs")
                            .onAppear {
                                fetchJobs()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // variable that holds the filtered jobs
    var filteredJobs: [Job] {
        guard !zipCode.isEmpty else {
            return jobs
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
            
            for job in jobs {
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
        return jobs
    }
    
    func miles2meters(miles: Double) -> Double{
        return (miles * 1609.34)
    }

    func fetchJobs() {
        loadError = false
        client.fetch(verb: "GET", endpoint: endpoint, auth: true) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                decoder.dateDecodingStrategy = .formatted(dateFormatter)

                if let decodedJobs = try? decoder.decode([Job].self, from: data) {
                    self.jobs = decodedJobs
                } else {
                    self.loadError = true
                    // TODO: handle decoding error
                }
            case .failure(_):
                self.loadError = true
                // TODO: handle networking error
            }
        }
    }
}

struct JobListView_Previews: PreviewProvider {
    static var previews: some View {
        JobListView(endpoint: "/jobs").environmentObject(Client())
    }
}