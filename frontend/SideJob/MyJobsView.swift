//
//  MyJobsView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI



struct MyJobsView: View {
    //@StateObject private var jobViewModel = JobService.shared
    @State var isfilter = false
    
    var body: some View {
        VStack {
            Text("Saved Jobs")
                .font(.system(size: 25)).padding(.bottom, 50)
            ScrollView {
                JobListView(endpoint: "/my/jobs", filteringByLocation: $isfilter)
            }
        }
        .frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct MyJobsView_Preview: PreviewProvider {
    static var previews: some View {
        MyJobsView()
    }
}
