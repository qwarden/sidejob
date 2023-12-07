//
//  JobView.swift
//  SideJob
//
//  Created by luke brown on 10/30/23.
//

import SwiftUI



struct JobView: View {
    let job: Job
    var profileDisabled: Bool
    var fromMyListings: Bool
    @State var showDeleteConfirmation = false
    @State var transitionToEdit = false
    @EnvironmentObject var client: Client
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        // Vertical stack for job content
        VStack(alignment: .leading, spacing: 10) {
            // Job title
            Text(job.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding([.top, .horizontal])
            
            // Job description
            Text(job.description)
                .font(.body)
                .foregroundColor(.secondary)
                .padding([.bottom, .horizontal])
            
            // Pay information
            HStack {
                Text(job.formattedPay)
                Text(job.payType)
            }
            .padding(.horizontal)
            
            // Job location
            Text(job.location)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding([.bottom, .horizontal])
            
            if (!fromMyListings) {
                // Navigation link to the details view
                NavigationLink(destination: DetailsView(job: job, profileDisabled: profileDisabled)) {
                    Text("View Details")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding([.bottom, .horizontal])
                }
                .buttonStyle(PlainButtonStyle())
            }
            else {
                HStack {
//                    NavigationLink(destination: EditPostView(job: job)) {
//                        Text("Edit Job")
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .frame(height: 44)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                            .padding([.bottom, .horizontal])
//                    }
//                    .buttonStyle(PlainButtonStyle())
                    
                    Button("Edit Job") {
                        EditPostView(job: job)
                        self.transitionToEdit = true
                    }.frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding([.bottom, .horizontal])
                    
                    
                    Button("Delete Job") {
                        self.showDeleteConfirmation = true
                    }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding([.bottom, .horizontal])
                    .alert(isPresented: $showDeleteConfirmation) {
                        Alert(
                            title: Text("Delete Job?"),
                            message: Text("This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                deleteJob()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                NavigationLink(destination: EditPostView(job: job), isActive: $transitionToEdit) {
                    EmptyView()
                }.hidden()
            }
        }
    }
    
    func deleteJob() {
        client.fetch(verb: "DELETE", endpoint: "/jobs/\(job.id)", auth: true) { (result: Result<Data, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.alertTitle = "Success"
                    self.alertMessage = "Job Deleted Successfully"
                    self.showAlert = true
                case .failure(_):
                    self.alertTitle = "Error"
                    self.alertMessage = "Job Deletion Failed"
                    self.showAlert = true
                }
            }
        }
    }
}
