//
//  AppView.swift
//  SideJob
//
//  Created by India Davis on 11/21/23.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        NavigationView{
            TabView {
                FeedView()
                    .tabItem {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                    }
            }
        }
        
       
    }
}

struct AppView_Preview: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
