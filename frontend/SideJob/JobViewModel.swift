//
//  JobViewModel.swift
//  SideJob
//
//  Created by Cael Christian on 11/9/23.
//

import SwiftUI

struct JobResponse: Decodable {
    let jobs: [Job]
}

class JobViewModel: ObservableObject {
    // @Published allows views to observe and react to changes
    @Published var jobs = [Job]()

    func fetchJobs() {
        // Replace with your server's actual endpoint URL
        guard let url = URL(string: "http://localhost:8080/jobs/") else {
            print("Invalid URL")
            return
        }
        print("Fetching jobs...")
        
    
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("HTTP Request failed: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }

            let rawJSONString = String(data: data, encoding: .utf8) ?? "Invalid data"
            print("Received JSON: \(rawJSONString)")
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            do {
                let decodedResponse = try decoder.decode(JobResponse.self, from: data)
                DispatchQueue.main.async {
                    self.jobs = decodedResponse.jobs
                }
            } catch {
                print("JSON Decoding failed: \(error)")
            }
        }.resume()
    }
}
