//
//  MyListingsView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI


struct MyListingsView: View {
    
    @EnvironmentObject var client: Client
    
    @State var endpoint = ""
    @State var jobs: [Job] = []
    @State var loadError: Bool = false
    
    @State private var showingPostView = false
    @State private var refreshID = UUID()
    
    @State var isUser: Bool
    var userID: Int
    

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                List {
                    ForEach(jobs) { job in
                        JobView(job: job, profileDisabled: true, fromMyListings: true)
                    }
                }
            }
            .navigationBarTitle("Listings", displayMode: .inline)
            
            .onAppear {
                if isUser {
                    self.endpoint = "my/jobs"
                }
                else {
                    let endpoint = "users/\(userID)/jobs"
                    self.endpoint = endpoint
                }
                fetchJobs()
            }
        }
    }
    
    func fetchJobs() {
        
        loadError = false
        client.fetch(verb: "GET", endpoint: self.endpoint, auth: true) { result in
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
                    self.jobs = decodedJobs
                    print(self.jobs)
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
