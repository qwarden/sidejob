//
//  MyListingsView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI



struct MyListingsView: View {
    @StateObject private var jobViewModel = JobService.shared
    
    var body: some View {
        VStack{
            Text("My Listings")
                .font(.system(size: 25)).padding(.bottom, 50)
            ScrollView{
                JobListView()
            }
        }.frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct MyListingsView_Preview: PreviewProvider {
    static var previews: some View {
        MyListingsView()
    }
}
