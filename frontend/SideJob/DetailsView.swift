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
    let job: Job
    
    
    //QUIMBY GET USERS INFO HERE FROM JOB.POSTEDBYID
    let poster = User()
    
    var body: some View {
        VStack(spacing: 30){
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.lightGray)
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity)
                    
                    ScrollView(){
                        
                        
                        Group{
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
                                .multilineTextAlignment(.leading).padding(.bottom, 20)
                        }
                        
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
                                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading).padding(.bottom, 20)
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
                                .scrollContentBackground(.hidden).padding(.bottom, 20)
                        }
                        
                        Group{
                            Text("Posted on")
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
                                .scrollContentBackground(.hidden).padding(.bottom, 20)
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
                                destination: PosterProfileView(postedById: job.postedByID),
                                label: {
                                    Text("\(poster.name)'s Profile")
                                        .padding(.horizontal, 80)
                                        .padding(.vertical, 20)
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                        .cornerRadius(10)
                                }
                                
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:  .topLeading)
                        }
                    }.padding(.horizontal, 15).padding(.vertical, 20)
                }
        }.navigationBarTitle(job.title)//vstack
        }//body
    }//view
    
    var testJob = Job(id: 420,
                      createdAt: Date(),
                      updatedAt: Date(),
                      deletedAt: Date(),
                      title: "Lawn Job",
                      description: "I need someone to come cut my grass. I have a really big yard and a lawn mower.",
                      payType: "Hourly",
                      payAmount: 20,
                      location: "05151",
                      postedByID: 123
                      )
    
    struct DetailsView_Previews: PreviewProvider {
        
        static var previews: some View {
            DetailsView(job: testJob)
        }
    }

