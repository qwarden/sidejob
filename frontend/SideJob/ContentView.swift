//
//  ContentView.swift
//  SideJob
//
//  Created by Quimby Warden on 10/4/23.
//

import SwiftUI

struct FeedView: View {
    //@State var  =
    
    var body: some View {
        VStack {
            PostView()
        }
    }
}

struct PostView: View {

    var body: some View {
        HStack() {
            Color(.blue)
                .frame(width: 200, height: 100)
            //left side
            VStack() {
                Rectangle().frame(width: 100, height: 100).foregroundColor(Color.red).offset(x: -75, y: -175)
            }
            //right side
            VStack() {
                
            }
        }
    }
}




struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
