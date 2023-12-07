//
//  ProfileView.swift
//  SideJob
//
//  Created by India Davis on 12/3
//

import SwiftUI

struct PosterProfileView: View {
    let poster: UserResponse
    
    @EnvironmentObject var client: Client
    
    @State private var navigateToNextView = false
    
    var body: some View {
            
            VStack(spacing: 20){
                
                Text("Username")
                    .font(.body).bold().padding(.top, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.lightGray)
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                    
                    Text(poster.name)
                        .font(.system(size: 20)).foregroundColor(.black)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                    
                }.frame(maxWidth: .infinity, maxHeight: 40)
                
                
                Text("Email")
                    .font(.body).bold().padding(.top, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.lightGray)
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                    
                    
                    Text(poster.email)
                        .font(.system(size: 20)).foregroundColor(.black)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                    
                }.frame(maxWidth: .infinity, maxHeight: 40)
                    .font(.system(size: 20)).foregroundColor(.darkGray)
                
                Text("About")
                    .font(.body)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                    .padding(.top, 15)
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.lightGray)
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity, maxHeight: 120)
                    Text(poster.about)
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: 120).padding(.horizontal, 35)
                        .padding(.horizontal, 15)
                        .scrollContentBackground(.hidden)
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment:  .top)
                
                NavigationLink(
                    destination: MyListingsView(isUser: false, userID: poster.id),
                    label: {
                        Text("\(poster.name)'s listings")
                        
                            .padding(.vertical, 20)
                            .padding(.horizontal, 80)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.top, 0)
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:  .top)
            }.navigationBarTitle("\(poster.name)'s Profile")
    }
}
