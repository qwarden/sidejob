//
//  AppView.swift
//  SideJob
//
//  Created by India Davis on 10/31/23.
//
import SwiftUI

struct AppView: View {
    var body: some View {
        NavigationView{
            TabView() {
                FeedView()
                    .tabItem() {
                        Image(systemName: "square.stack")
                    }
                ProfileView()
                    .tabItem() {
                        Image(systemName: "person")
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
