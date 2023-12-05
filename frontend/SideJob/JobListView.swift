//
//  JobListView.swift
//  SideJob
//
//  Created by India Davis on 11/9/23.
//

import SwiftUI

struct JobListView: View {
    @EnvironmentObject var client: Client
    @State var jobs: [Job] = []
    @State var loadError: Bool = false
    var endpoint: String

    var body: some View {
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
            }
            .onAppear {
                fetchJobs()
            }
        }

        private func fetchJobs() {
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
