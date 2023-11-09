//
//  ContentView.swift
//  SideJob
//
//  Created by Quimby Warden on 10/4/23.
//

import SwiftUI

struct Job{
    let title : String
    let description : String
    let price : String
    let postedBy : String
    let saved: Bool
}

//hard coded example
let post1 = Job(title: "Lawn Job", description: "Cut my grass", price: "30", postedBy: "India", saved: false)
let post2 = Job(title: "Paint Job", description: "Paint my house", price: "25", postedBy: "India", saved: false)
let post3 = Job(title: "Paint Job", description: "Paint my house", price: "25", postedBy: "India", saved: false)


 
struct JobView: View {
    let job : Job
    
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
                Text(job.title)
                    .frame(alignment: .top)
                    .font(.system(size: 30))
                    .foregroundColor(Color.black)
                    .bold()
                    .padding(10)
                Text(job.description)
                    .foregroundColor(Color.black)
                Text("\(job.price)$ per hour")
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


struct FeedView: View {
    var postList = [Job]()
    
    //postList.append(post1)
    
    
    var body: some View {
        VStack() {
            
            //THIS NEEDS TO BE A LOOP
            JobView(job: post1).background(Color(red: 0.7, green: 0.8, blue: 1.0)).cornerRadius(5).padding(10)
            JobView(job: post2).background(Color(red: 0.7, green: 0.8, blue: 1.0)).cornerRadius(5).padding(10)
            JobView(job: post3).background(Color(red: 0.7, green: 0.8, blue: 1.0)).cornerRadius(5)
                .padding(10)
        }
    }
}


struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
