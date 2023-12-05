//
//  DetailsView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI
struct DetailsView: View {
    let job: Job

    var body: some View {
        NavigationView{
            VStack {
                VStack {
                    Text("\(job.title)")
                        .padding(5)
                        .font(.title)
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.7, green: 0.8, blue: 1.0))
                .foregroundColor(Color.black)
                .cornerRadius(40)
                .padding(.bottom, 20)
                .padding(10)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Basic Info")
                        .font(.headline)
                        .padding([.top, .bottom], 10)
                    Text("Description: \(job.description)")
                        .padding([.horizontal, .bottom], 20)
                    Text("Location: \(job.location)")
                        .padding([.horizontal, .bottom], 20)
                    Text("$\(job.payAmount) per hour")
                        .padding([.horizontal, .bottom], 20)
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.7, green: 0.8, blue: 1.0))
                .foregroundColor(Color.black)
                .cornerRadius(40)
                .padding(.bottom, 20)
                .padding(10)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Additional Info")
                        .font(.headline)
                        .padding([.top, .bottom], 10)
                    Text("Pay: \(job.payType)")
                        .padding([.horizontal, .bottom], 20)
                    NavigationLink(destination: PosterProfileView(poster: UserInfo)) {
                            Text("Posted By: \(job.postedByID)")
                                .padding([.horizontal, .bottom], 20)
                        }
                        .foregroundColor(Color.black)

                    Text("Created on: \(job.formattedPostedDate)")
                        .padding([.horizontal, .bottom], 20)
                    Text("Edited on: \(job.formattedUpdatedDate)")
                        .padding([.horizontal, .bottom], 20)
                    Text("Contact: job.email@chess.com")
                        .padding([.horizontal, .bottom], 20)
                        .foregroundColor(Color.black)
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.7, green: 0.8, blue: 1.0))
                .foregroundColor(Color.black)
                .cornerRadius(40)
                .padding(.bottom, 30)
                .padding(10)
                Spacer()
            }
        }
        
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(job: testJob)
    }
}

let testJob = Job(id: 420,
                  createdAt: Date(),
                  updatedAt: Date(),
                  title: "Lawn Job",
                  description: "Cut my grass",
                  payAmount: 20,
                  location: "05151",
                  postedByID: 420,
                  payType: "Hourly")
