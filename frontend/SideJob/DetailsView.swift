//
//  DetailsView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI
import Foundation

extension Color{
    static let buttonColor = Color(red: 60/255, green: 100/255, blue: 150/255)
    static let darkGray = Color(red: 100/255, green: 100/255, blue: 100/255)
    static let lightGray = Color(red: 240/255, green: 240/255, blue: 240/255)
}

struct DetailsView: View {
    @State private var poster: UserResponse = UserResponse()
    let job: Job
    @EnvironmentObject private var client: Client
    var profileDisabled: Bool
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                Group {
                    Text("Description")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.darkGray)
                        .padding(.bottom, 2)
                    
                    Text(job.description)
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                }

                Group {
                    Text("Pay")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.darkGray)
                        .padding(.bottom, 2)
                    
                    Text(String(format: "$%.2f \(job.payType)", job.payAmount))
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                }

                Group {
                    Text("Location Zip")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.darkGray)
                        .padding(.bottom, 2)
                    
                    Text(job.location)
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                }

                Group {
                    Text("Posted On")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.darkGray)
                        .padding(.bottom, 2)
                    
                    Text(job.createdAt.formatted(date: .complete, time: .omitted))
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                }

                if (!profileDisabled) {
                    Group{
                        
                        Text("Posted By")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.darkGray)
                            .padding(.bottom, -5)
                        
                        
                        NavigationLink(
                            destination: PosterProfileView(poster: poster),
                            label: {
                                Text("\(poster.name)'s Profile")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                                    .cornerRadius(10)
                            }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:  .topLeading)
                    }
                }
            }
            .padding(.horizontal, 35)
            .padding(.vertical, 20)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.lightGray))
            .padding(.horizontal, 15)
        }
        .navigationBarTitle(job.title)
        .onAppear {
            loadUser(id: job.postedByID)
        }
    }
    
    
    func loadUser(id: Int) {
        client.fetch(verb: "GET", endpoint: "/users/\(id)", auth: true) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    
                    let user = try decoder.decode(UserResponse.self, from: data)
                    self.poster = user
                } catch {
                    print("Decoding error: \(error)")
                }
            case .failure(let error):
                print("Fetch error: \(error)")
            }
        }
    }

}//view
