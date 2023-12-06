//
//  Client.swift
//  SideJob
//
//  Created by Quimby Warden on 12/3/23.
//

import Foundation

class Tokens: Codable {
    var accessToken: String
    var refreshToken: String
        
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
    
    init(accessToken: String, refreshToken: String){
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(refreshToken, forKey: .refreshToken)
    }

}

enum NetworkError: Error {
    case networkFailure(Error)
    case noData
    case unauthorized
}

class Client: ObservableObject {
    let baseURL: URL
    let session: URLSession
    var tokens: Tokens?
    let tokenPath: String
    @Published var loggedIn: Bool
    
    init() {
        if let url = URL(string: "http://localhost:8080") {
            self.baseURL = url
        } else {
            fatalError("Invalid base URL")
        }
        self.loggedIn = false
        self.session = URLSession.shared
        self.tokenPath = "tokens.json"
    }
    
    func initialize() {
        if loadTokens() {
            fetch(verb: "GET", endpoint: "/my/profile", auth: true) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.loggedIn = true
                    case .failure(_):
                        self.loggedIn = false
                    }
                }
            }
        }
    }
    
    func logout() {
        let emptyTokens = Tokens(accessToken: "", refreshToken: "")
        // Save the empty tokens
        saveTokens(emptyTokens)
        // Set the loggedIn state to false
        loggedIn = false
    }
    
    func refreshTokens(completion: @escaping (Bool) -> Void) {
           let url = baseURL.appendingPathComponent("/auth/refresh")
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = ["refresh_token": self.tokens?.refreshToken]
           do {
               request.httpBody = try JSONEncoder().encode(body)
           } catch {
               completion(false)
               return
           }

           session.dataTask(with: request) { data, response, error in
               if error != nil {
                   completion(false)
                   return
               }
               guard let data = data else {
                   completion(false)
                   return
               }

               do {
                   let refreshedTokens = try JSONDecoder().decode(Tokens.self, from: data)
                   self.tokens = refreshedTokens
                   self.saveTokens(refreshedTokens)
                   completion(true)
               } catch {
                   completion(false)
               }
           }.resume()
       }
    
    func fetch(verb: String, endpoint: String, auth: Bool, data: Data? = nil, completion: @escaping (Result<Data,NetworkError>) -> Void) {
        let url = baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = verb
        
        if auth {
            if let accToken = tokens?.accessToken {
                request.setValue("Bearer \(accToken)", forHTTPHeaderField: "Authorization")
            }
        }
        

        if let data = data {
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        session.dataTask(with: request) { responseData, response, error in
            if let error = error {
                completion(.failure(.networkFailure(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }

            if httpResponse.statusCode == 401 {
                self.refreshTokens { success in
                    if success {
                        self.fetch(verb: verb, endpoint: endpoint, auth: auth, data: data, completion: completion)
                    } else {
                        completion(.failure(.unauthorized))
                    }
                }
            }
            else if let responseData = responseData {
                completion(.success(responseData))
            } else {
                completion(.failure(.noData))
            }
        }.resume()
    }
    
    func saveTokens(_ tokens: Tokens) {
        let url: URL = {
            let dirs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let dir = dirs.first!
            return dir.appendingPathComponent(self.tokenPath)
        }()

        do {
            let data = try JSONEncoder().encode(tokens)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Error saving tokens: \(error)")
        }
    }
    
    func loadTokens() -> Bool {
        let url: URL = {
            let dirs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let dir = dirs.first!
            return dir.appendingPathComponent(self.tokenPath)
        }()
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            self.tokens = try decoder.decode(Tokens.self, from:data)
            return true
        } catch {
            self.tokens = nil
            return false
        }
    }
}
