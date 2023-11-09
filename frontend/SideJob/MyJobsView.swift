//
//  MyJobsView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI



struct MyJobsView: View {
  
    //HARD CODED: CHANGE LATER
    let myJobsArray : [Post] = [
        Post(title: "Lawn Job", description: "Cut my grass", price: "30", postedBy: "India"),
        Post(title: "Paint Job", description: "Paint my house", price: "25", postedBy: "India"),
        Post(title: "Paint Job", description: "Paint my house", price: "25", postedBy: "India")
    ]
    
    var body: some View {

        
        
        VStack{
            Text("Saved Jobs")
                .font(.system(size: 25)).padding(.bottom, 50)
            ScrollView{
                Text("Test")
                Text("Test 2")
                Text("Test 3")
            }
           
        }.frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        
        
    }
}

struct MyJobsView_Preview: PreviewProvider {
    static var previews: some View {
        MyJobsView()
    }
}

