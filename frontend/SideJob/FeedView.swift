//
//  ContentView.swift
//  SideJob
//
//  Created by Quimby Warden on 10/4/23.
//

import SwiftUI

struct FeedView: View {
    var jobList = [Job]()
    //postList.append(post1)
    
    
    var body: some View {
        NavigationView{
            Text("Feed")
                .frame(alignment: .top)
            JobListView()
        }
    }
}



struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
