//
//  ProfileView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/13/23.
//

import SwiftUI

extension Color{
    static let buttonColor = Color(red: 100/255, green: 100/255, blue: 170/255)
    static let darkGray = Color(red: 100/255, green: 100/255, blue: 100/255)
}

struct ProfileView: View {
    @State private var showingAlert = false
    @State private var backToWelcome = false
    

    //@Binding var imageName: String
    var body: some View {
     
        @State var askToSignOut: Bool = false
        
        @State var test: String = "Test"
        
        NavigationView{
            ScrollView(.vertical){
                
                VStack(spacing: 30){
                    
                    HStack(){
                        Button(){
                            
                        }label: {
                            Text("Edit")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        
                        Text("Profile")
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        
                        NavigationLink("Sign Out"){
                            WelcomeView().navigationBarBackButtonHidden(true)
                        }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 30)
                        
                        /*
                        Button("Sign Out") {
                            showingAlert = true
                            
                        }.alert("Are you sure you want to sign out?", isPresented: $showingAlert) {
                            Button("Cancel") { }
                            NavigationLink(destination: WelcomeView(), label: {
                                Text("Sign Out")
                            })
                        }
                        */
                     
                    }
                    
                }
                
                Text("username1234")
                    .font(.system(size: 20)).foregroundColor(.darkGray).padding(.top, 15)
                //HARD CODED: CHANGE THIS TO BE FROM ACTUAL USER
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 300, height: 300)
        
                VStack(spacing: 40){
                    NavigationLink(
                       destination: MyListingsView(),
                       label: {
                           Text("My Listings").padding(30).font(.system(size: 25))
                       }
                    ).foregroundColor(.white)
                        .background(Color.buttonColor)
                        .cornerRadius(10)
                    
                    NavigationLink(
                       destination: MyJobsView(),
                       label: {
                           Text("Saved Jobs").padding(30).font(.system(size: 25))
                       }
                    ).foregroundColor(.white)
                        .background(Color.buttonColor)
                        .cornerRadius(10)
                        
                }.padding(.top, 50)
                
                
                
            }
            
                
           

                    
                }
                .frame( maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            
            
        }
    





struct ProfileView_Preview: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
