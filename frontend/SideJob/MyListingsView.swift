//
//  MyListingsView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI



struct MyListingsView: View {
    
    let strings: [String] = ["test", "test2", "test3"]
    
    var body: some View {
        VStack{
            Text("My Listings")
                .font(.system(size: 25)).padding(.bottom, 50)
            Text("listing Test")
            Text("listing Test 2")
            Text("listing Test 3")
        }.frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct MyListingsView_Preview: PreviewProvider {
    static var previews: some View {
        MyListingsView()
    }
}
