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
    @EnvironmentObject private var locationObject: LocationManager
    var endpoint: String
    @Binding var filteringByLocation: Bool
    var refreshID: UUID
    
    @Binding var radius: Int
    @Binding var userZipCode: String
    @Binding var isFiltering: Bool
    @State private var filteredJobs: [Job] = []
    
    
    var body: some View {
        VStack {
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        List {
                            if jobs.isEmpty && filteredJobs.isEmpty && !loadError {
                                Text("Loading jobs...")
                            } else if loadError {
                                Button("Tap to retry") {
                                    fetchJobs()
                                }
                            } else {
                                if filteringByLocation {
                                    ForEach(filteredJobs) { job in
                                        JobView(job: job, profileDisabled: false, fromMyListings: false)
                                    }
                                }
                                else {
                                    ForEach(jobs) { job in
                                        JobView(job: job, profileDisabled: false, fromMyListings: false)
                                    }
                                }
                            }
                        }
                    }
                    
                }
        }
        .onAppear {
            fetchJobs()
        }
        .onChange(of: refreshID) { _ in
            fetchJobs()
        }
        .onChange(of: isFiltering) { _ in
            // When isFiltering changes, update the filtered jobs
            if isFiltering {
                computeFilterJobs()
            }
        }
    }
    
    // this is just to initiate the computed filter jobs variable which then updates the jobs
    func computeFilterJobs() {
        let _ = computedFilterJobs
    }
    // variable that holds the filtered jobs
    var computedFilterJobs: [Job] {
        // location filtering
        if filteringByLocation {
            guard !userZipCode.isEmpty else {
                return jobs
            }
            
            var filteredJobs: [Job] = []
            let dispatchGroup = DispatchGroup()
            
            locationObject.getLocationFromZipCode(from: userZipCode) { zipCodeLocation in
                guard let userLocation = zipCodeLocation else {
                    // Handle the case where the location could not be determined from the zip code
                    dispatchGroup.notify(queue: .main) {
                        // The asynchronous operations are completed
                        // Now you can use the filteredJobs array
                        print("Filtered Jobs: \(filteredJobs)")
                        self.filteredJobs = filteredJobs
                        self.isFiltering = false
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
                            let radius: CLLocationDistance = CLLocationDistance(miles2meters(miles: Double(radius)))
                            
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
                    self.isFiltering = false
                    self.filteredJobs = filteredJobs
                }
            }
        }
        else {
            return jobs
        }
        // This is a temporary return value; the actual filteredJobs will be available after the completion handler is called
        return []
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
                
                do {
                    let decodedJobs = try decoder.decode([Job].self, from: data)
                    self.jobs = decodedJobs.sorted { $0.updatedAt > $1.updatedAt }
                } catch {
                    self.loadError = true
                    
                    print("Error decoding jobs: \(error.localizedDescription)")
                }
            case .failure(_):
                self.loadError = true
            }
        }
    }
}
