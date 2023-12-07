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
    @Published var loggedIn: Bool
    private let baseURL: URL
    private let session: URLSession
    private var tokens: Tokens?
    private let tokenPath: String
    private let prod: Bool = false
    private let tokenRefreshSemaphore = DispatchSemaphore(value: 1)
    private var retryCount = 0
    
    init() {
        
        let url: URL?
        
        if prod {
            url = URL(string: "https://sidejob.fly.dev")
        } else {
            url = URL(string: "http://localhost:8080")
        }
        
        if url != nil {
            self.baseURL = url!
        } else {
            fatalError("Invalid base URL")
        }
        self.loggedIn = false
        self.session = URLSession.shared
        self.tokenPath = "tokens.json"
    }

    func fetch(verb: String, endpoint: String, auth: Bool, data: Data? = nil, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let url = baseURL.appendingPathComponent(endpoint)
        var request = URLRequest(url: url)
        request.httpMethod = verb

        if auth, let accToken = tokens?.accessToken {
            let authHeader = "Bearer \(accToken)"
            request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        }

        if let data = data {
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let headers = request.allHTTPHeaderFields, let authHeader = headers["Authorization"] {
            print("Authorization Header: \(authHeader)")
        } else {
            print("Authorization header not found")
        }      
        print("Request: \(request)")
        print("Making request to \(endpoint)")

        session.dataTask(with: request) { responseData, response, error in
            if let error = error {
                print("Request failed with error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(.networkFailure(error)))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("No valid HTTP response received.")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            if httpResponse.statusCode == 401 {
                print("Received 401 Unauthorized.")

                if let data = responseData, let errorString = String(data: data, encoding: .utf8) {
                    print("Detailed error from server: \(errorString)")
                }

                if self.retryCount < 3 {
                    self.retryCount += 1

                    self.tokenRefreshSemaphore.wait()
                    print("Starting token refresh.")

                    self.refreshTokens { success in
                        self.tokenRefreshSemaphore.signal()

                        if success {
                            print("Token refreshed successfully. Reloading tokens and retrying request.")
                            _ = self.loadTokens()
                            self.fetch(verb: verb, endpoint: endpoint, auth: auth, data: data, completion: completion)
                        } else {
                            print("Token refresh failed.")
                            DispatchQueue.main.async {
                                self.retryCount = 0
                                completion(.failure(.unauthorized))
                            }
                        }
                    }
                } else {
                    print("Maximum retry attempts reached.")
                    DispatchQueue.main.async {
                        self.retryCount = 0
                        completion(.failure(.unauthorized))
                    }
                }
            } else {
                if let responseData = responseData {
                    print("Request to \(endpoint) successful.")
                    DispatchQueue.main.async {
                        self.retryCount = 0
                        completion(.success(responseData))
                    }
                } else {
                    print("Response data is nil.")
                    DispatchQueue.main.async {
                        self.retryCount = 0
                        completion(.failure(.noData))
                    }
                }
            }
        }.resume()
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
        self.tokens = nil
        let emptyTokens = Tokens(accessToken: "", refreshToken: "")
        saveTokens(emptyTokens)
        loggedIn = false
    }
    
    func refreshTokens(completion: @escaping (Bool) -> Void) {
        print("refresh")
        guard let refreshToken = self.tokens?.refreshToken else {
            completion(false)
            return
        }
        
        let url = baseURL.appendingPathComponent("/auth/refresh")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["refresh_token": refreshToken]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Error encoding refresh token: \(error)")
            completion(false)
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error refreshing token: \(error)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false)
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Refresh token failed with status code: \(httpResponse.statusCode)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received during token refresh")
                completion(false)
                return
            }
            
            do {
                let refreshedTokens = try JSONDecoder().decode(Tokens.self, from: data)
                self.saveTokens(refreshedTokens)
                completion(true)
            } catch {
                print("Error decoding refreshed tokens: \(error)")
                completion(false)
            }
        }.resume()
    }
    
    func saveTokens(_ tokens: Tokens) {
        self.tokens = tokens
        let url: URL = {
            let dirs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let dir = dirs.first!
            return dir.appendingPathComponent(self.tokenPath)
        }()

        do {
            let data = try JSONEncoder().encode(tokens)
            try data.write(to: url, options: [.atomic])
            print("Tokens saved")
        } catch {
            print("Error saving tokens: \(error)")
        }
    }
    
    func updateTokens(newTokens: Tokens) {
        self.tokens = newTokens
        saveTokens(newTokens)
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
            print("Tokens loaded")
            return true
        } catch {
            self.tokens = nil
            print("Error loading tokens")
            return false
        }
    }
}
