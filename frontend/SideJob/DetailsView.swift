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
    
    var body: some View {
        VStack(spacing: 5){
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.lightGray)
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity)
                
                ScrollView(){
                    Text("Description")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 35)
                        .foregroundColor(.darkGray)
                        .padding(.bottom, -5)

                    Text(job.description)
                        .font(.system(size: 20)).foregroundColor(.black)
                        .padding(.horizontal, 35)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 20)

                                        
                    Group{
                        Text("Pay")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 35)
                            .foregroundColor(.darkGray)
                            .padding(.bottom, -5)

                        
                        Text("$\(job.payAmount) \(job.payType)")
                            .font(.system(size: 20)).foregroundColor(.black)
                            .padding(.horizontal, 35)
                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                            .padding(.bottom, 20)

                    }
                    
                    Group{
                        Text("Location Zip")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 35)
                            .foregroundColor(.darkGray)
                            .padding(.bottom, -5)

                        
                        Text(job.location)
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: 120, alignment: .leading).padding(.horizontal, 35)
                            .scrollContentBackground(.hidden)
                            .padding(.bottom, 20)
                    }
                    
                    Group{
                        Text("Posted On")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 35)
                            .foregroundColor(.darkGray)
                            .padding(.bottom, -5)

                        
                        Text(job.createdAt.formatted(date: .complete, time: .omitted))
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: 120, alignment: .leading).padding(.horizontal, 35)
                            .scrollContentBackground(.hidden)
                            .padding(.bottom, 20)

                    }
                    
                    Group{
                        
                        Text("Posted By")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 35)
                            .foregroundColor(.darkGray)
                            .padding(.bottom, -5)

                        
                        NavigationLink(
                            destination: PosterProfileView(poster: poster),
                            label: {
                                Text("\(poster.name)'s Profile")
                                    .padding(.horizontal, 35)
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                                    .cornerRadius(10)
                            }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:  .topLeading)
                    }
                }.padding(.horizontal, 15).padding(.vertical, 20)
            }
        }.navigationBarTitle(job.title).onAppear {
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
