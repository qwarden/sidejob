//
//  ContentView.swift
//  SideJob
//
//  Created by Quimby Warden on 10/4/23.
//

import SwiftUI

struct FeedView: View {
    var postList = [Post]()
    
    let post1 = Post(title: "Lawn Job", description: "Cut my grass", price: "30", postedBy: "India")
    let post2 = Post(title: "Paint Job", description: "Paint my house", price: "25", postedBy: "India")
    let post3 = Post(title: "Paint Job", description: "Paint my house", price: "25", postedBy: "India")
    
    //postList.append(post1)
    
    
    var body: some View {
        VStack() {
            PostView(post: post1).background(Color(red: 0.7, green: 0.8, blue: 1.0)).cornerRadius(5).padding(10)
            PostView(post: post2).background(Color(red: 0.7, green: 0.8, blue: 1.0)).cornerRadius(5).padding(10)
            PostView(post: post3).background(Color(red: 0.7, green: 0.8, blue: 1.0)).cornerRadius(5)
                .padding(10)
        }
    }
}

struct Post{
    let title : String
    let description : String
    let price : String
    let postedBy : String
}

struct PostView: View {
    let post : Post
    
    var body: some View {
        HStack() {
            //left side
            VStack() {
               
                Button(){
                    
                } label: {
                    Text("I'm Interested")
                        .background(.red)
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                        .frame(width: 150, height: 110, alignment: .bottom)
                        
                }
                    
            }
            //right side
            VStack(alignment: .leading) {
                Text(post.title)
                    .frame(alignment: .top)
                    .font(.system(size: 30))
                    .foregroundColor(Color.black)
                    .bold()
                    .padding(10)
                Text(post.description)
                    .foregroundColor(Color.black)
                Text("\(post.price)$ per hour")
                    .foregroundColor(Color.black)
                    .font(.system(size: 20))
                    

                Button(){
                    
                } label: {
                    Text("View")
                        .background(.red)
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                        .frame(width: 75, height: 30)
                }
                
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
