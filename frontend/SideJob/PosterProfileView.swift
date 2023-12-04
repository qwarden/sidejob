//
//  ProfileView.swift
//  SideJob
//
//  Created by India Davis on 12/3
//

import SwiftUI

struct PosterProfileView: View {
    //DELETE THIS EXAMPLE USER
    @State private var poster = User(username: "idavis1", email: "idavis1@uvm.edu", about: "dsfafdsfsf")

    @EnvironmentObject var userTokens: UserTokens
    
    @State private var navigateToNextView = false
    @State var test: String = "Test"
    
    //@Binding var imageName: String
    var body: some View {
        
        VStack(spacing: 20){
            
            Text(poster.username)
                .font(.system(size: 25))
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Username:")
                .font(.system(size: 20)).padding(.top, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.lightGray)
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                
                TextField("", text: $poster.username)
                    .font(.system(size: 20)).foregroundColor(.black)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                
            }.frame(maxWidth: .infinity, maxHeight: 40)
            
            
            Text("Email:")
                .font(.system(size: 20)).padding(.top, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.lightGray)
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                
                
                TextField("", text: $poster.email)
                    .font(.system(size: 20)).foregroundColor(.black)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                
            }.frame(maxWidth: .infinity, maxHeight: 40)
                .font(.system(size: 20)).foregroundColor(.darkGray)
            
            Text("About:")
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
                .padding(.top, 15)
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.lightGray)
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, maxHeight: 120)
                TextEditor(text: $poster.about)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: 120).padding(.horizontal, 35)
                    .padding(.horizontal, 15)
                    .scrollContentBackground(.hidden)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment:  .top)
            
            NavigationLink(
                destination: MyListingsView(),
                label: {
                    Text("\(poster.username)'s listings")
                    
                        .padding(.vertical, 20)
                        .padding(.horizontal, 80)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .background(Color.buttonColor)
                        .cornerRadius(10)
                        .padding(.top, 0)
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment:  .top)
        }
    }
    
    struct PosterProfileView_Preview: PreviewProvider {
        static var previews: some View {
            PosterProfileView().environmentObject(UserTokens())
        }
    }
    
    
}
