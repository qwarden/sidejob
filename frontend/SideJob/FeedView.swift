//
//  ContentView.swift
//  SideJob
//
//  Created by Quimby Warden on 10/4/23.
//

import SwiftUI

struct FeedView: View {
    var jobList = [Job]()
    
    let job1 = Job(title: "Lawn Job", description: "Cut my grass", price: "30", postedBy: "India")
    let job2 = Job(title: "Paint Job", description: "Paint my house", price: "25", postedBy: "India")
    let job3 = Job(title: "Paint Job", description: "Paint my house", price: "25", postedBy: "India")
    
    //postList.append(post1)
    
    
    var body: some View {
        NavigationView{
            VStack() {
                JobView(job: job1).background(Color(red: 0.7, green: 0.8, blue: 1.0)).cornerRadius(5).padding(10)
                JobView(job: job2).background(Color(red: 0.7, green: 0.8, blue: 1.0)).cornerRadius(5).padding(10)
                JobView(job: job3).background(Color(red: 0.7, green: 0.8, blue: 1.0)).cornerRadius(5)
                    .padding(10)
            }
        }
    }
}


// TAB VIEW
struct TabViewDemo: View {
    @State var selection = 1
    init() {
    UITabBar.appearance().backgroundColor = UIColor.gray
    }
    
    var body: some View {
        TabView(selection: $selection) {
            FeedView()
                .tabItem() {
                    Image(systemName: "list.bullet")
                }.tag(1)
            ProfileView()
                .tabItem() {
                    Image(systemName: "person")
                }.tag(2)
            
        }
    }
}


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
