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
    @Binding var radius: Int
    @Binding var userZipCode: String
    @State private var stateFilteredJobs: [Job] = []


    var body: some View {
        VStack {
            NavigationView {
                // Add a button at the top to transition to the Filter View
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        List {
                            if jobs.isEmpty && !loadError {
                                Text("Loading jobs...")
                            } else if loadError {
                                Button("Tap to retry") {
                                    fetchJobs()
                                }
                            } else {
                                ForEach(stateFilteredJobs) { job in
                                    JobView(job: job)
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
                        self.stateFilteredJobs = filteredJobs
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
                    self.stateFilteredJobs = filteredJobs
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
                print(data)
                let decoder = JSONDecoder()
                //decoder.dateDecodingStrategy = .iso8601
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                decoder.dateDecodingStrategy = .formatted(dateFormatter)

                do {
                    let decodedJobs = try decoder.decode([Job].self, from: data)
                    self.jobs = decodedJobs
                } catch {
                    self.loadError = true
                    print("Error decoding jobs: \(error.localizedDescription)")
                    // TODO: handle decoding error
                }
            case .failure(_):
                self.loadError = true
                // TODO: handle networking error
            }
        }
    }
}

//struct JobListView_Previews: PreviewProvider {
//    @State static var isFilteringByLocation = true
//    static var previews: some View {
//        JobListView(endpoint: "/jobs", filteringByLocation: $isFilteringByLocation).environmentObject(Client())
//    }
//}
