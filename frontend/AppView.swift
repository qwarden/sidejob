//
//  AppView.swift
//  SideJob
//
//  Created by India Davis on 10/31/23.
//
import SwiftUI

struct AppView: View {
    @EnvironmentObject private var locationManager: LocationManager
    
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

            }.onAppear{
                locationManager.requestAuthorization()
            }
        }
    }

}


struct AppView_Preview: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
