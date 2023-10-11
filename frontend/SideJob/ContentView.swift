//
//  ContentView.swift
//  SideJob
//
//  Created by Quimby Warden on 10/4/23.
//

import SwiftUI

struct FeedView: View {
    
    let post1 = Post(title: "Lawn Job", description: "Cut my grass", price: "30", postedBy: "India")
    let post2 = Post(title: "Paint Job", description: "Paint my house", price: "25", postedBy: "India")
    let post3 = Post(title: "Paint Job", description: "Paint my house", price: "25", postedBy: "India")
    
    var body: some View {
        VStack {
            PostView(post: post1)
            PostView(post: post2)
            PostView(post: post3)
            
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
        //background
        Color(red: 0.7, green: 0.8, blue: 1.0)
            .frame(width: 300, height: 200)
            .cornerRadius(10)
        
        HStack() {
            //left side
            VStack() {
               
                Button(){
                    
                } label: {
                    Text("I'm Interested")
                        .background(.red)
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                        .frame(width: 150, height: 30)
                        .offset(x: 0, y: -110)
                }
                    
            }
            //right side
            VStack(alignment: .leading) {
                Text(post.title)
                    .frame(alignment: .top)
                    .font(.system(size: 30))
                    .foregroundColor(Color.black)
                    .bold()
                    .offset(x: 0, y: -200)
                Text(post.description)
                    .foregroundColor(Color.black)
                    .offset(x:0, y: -180)
                Text("\(post.price)$ per hour")
                    .foregroundColor(Color.black)
                    .offset(x:0, y: 0)
                    .font(.system(size: 20))
                    .offset(x:0, y: -180)

                Button(){
                    
                } label: {
                    Text("View")
                        .background(.red)
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                        .frame(width: 75, height: 30)
                        .offset(x: 0, y: -165)
                }
                
            }
        }
    }
}




struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        
      
        FeedView()
    }
}
