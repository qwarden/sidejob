//
//  MyListingsView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

//import SwiftUI
//
//
//
//struct ListingsView: View {
//       let user: UserInfo
//
//       init(user: UserInfo) {
//           self.user = user
//       }
//    
//    
//    // Using ObservedObject to observe changes in the shared JobService instance
//    @ObservedObject var jobService = JobService.shared
//    @State private var showingPostView = false
//    
//    var body: some View {
//      NavigationView {
//            Text(user.name)
//            ZStack(alignment: .bottomTrailing) {
//                // List of jobs, each represented by JobView
//                
//                List(jobService.jobs.filter {$0.postedByID == user.userID}) { job in
//                    JobView(job: job)
//                }
//                 
//                // Fetch jobs when the view appears
//                .onAppear {
//                    jobService.fetchJobs()
//                }
//            }
//      
//            // Present the PostView as a sheet
//            .sheet(isPresented: $showingPostView) {
//                PostView()
//            }
//        }
//    }
//}
