//
//  ProfileView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/13/23.
//

import SwiftUI



struct User{
    var username : String;
    var email : String;
    var about : String;
    var myListings : Array<Job>
}
var job1 = Job(title: "Lawn Job", description: "cut my grass", price: "$35 an hour", postedBy: "user5093")
var job2 = Job(title: "Other Job", description: "ksjdfkjh", price: "$35 an hour", postedBy: "user24341")

extension Color{
    static let buttonColor = Color(red: 60/255, green: 100/255, blue: 150/255)
    static let darkGray = Color(red: 100/255, green: 100/255, blue: 100/255)
    static let lightGray = Color(red: 220/255, green: 230/255, blue: 270/255)
}

struct ProfileView: View {
    
    // HARD CODED EXAMPLE USER
    
    @State private var user = User(username: "idavis1", email: "idavis1@uvm.edu", about: "Hi, my name is India and I want to work for you. This is all information about me. I can paint and cut grass and do whatever. Feel free to reach out to me I am available always. This is example about text", myListings: [job1, job2])
    //END EXAMPLE USER
    
    
    
    @State private var showSaveAlert = false
    @State private var showAlert = false
    @State private var navigateToNextView = false
    @State private var isEditing = false
    
    //@Binding var imageName: String
    var body: some View {
        
        @State var askToSignOut: Bool = false
        @State var test: String = "Test"
        
      
            VStack(spacing: 20){
                
                HStack(){
                    
                    Text("").frame(maxWidth: .infinity, alignment: .leading)
                    if (isEditing == false){
                        Text("Profile")
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    else{
                        Text("Edit Profile")
                            .font(.system(size: 25))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Done" : "Edit")
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 30)
                        .font(.system(size: 20))
                    
                }
                
                Text("Username:")
                    .font(.system(size: 20)).padding(.top, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.lightGray)
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                    if (isEditing == false){
                        Text(user.username)
                            .font(.system(size: 20)).foregroundColor(.darkGray)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                    }
                    else{
                        TextField("", text: $user.username)
                            .font(.system(size: 20)).foregroundColor(.black)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                    }
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
                    if (isEditing == false){
                        Text(user.email)
                            .font(.system(size: 20)).foregroundColor(.darkGray)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                    }
                    else{
                        TextField("", text: $user.email)
                            .font(.system(size: 20)).foregroundColor(.black)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                    }
                    
                }.frame(maxWidth: .infinity, maxHeight: 40)
                    .font(.system(size: 20)).foregroundColor(.darkGray)
                
                Text("About:")
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                    .padding(.top, 15)
                
                ZStack {
                    if (isEditing == false){
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.lightGray)
                            .padding(.horizontal, 30)
                            .frame(maxWidth: .infinity, maxHeight: 120)
                        ScrollView(.vertical){
                            Text(user.about)
                                .font(.system(size: 20))
                                .foregroundColor(.darkGray)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                        }.frame(maxWidth: .infinity, maxHeight: 120).padding(.horizontal, 35)
                    }
                    else{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.lightGray)
                            .padding(.horizontal, 30)
                            .frame(maxWidth: .infinity, maxHeight: 120)
                        TextEditor(text: $user.about)
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: 120).padding(.horizontal, 35)
                            .padding(.horizontal, 15)
                            .scrollContentBackground(.hidden)
                    }
                    
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment:  .top)
                
                
                //buttons at bottom---------------------------------------------------------------------------
                
                VStack(spacing: 10){
                    
                    if isEditing{
                        Text("My Listings").padding(.vertical, 20).padding(.horizontal, 80).font(.system(size: 20))
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(10)
                            .padding(.top, 0)
                    }
                    else{
                        NavigationLink(
                            destination: MyListingsView(),
                            label: {
                                Text("My Listings").padding(.vertical, 20).padding(.horizontal, 80).font(.system(size: 20))
                            }
                        ).foregroundColor(.white)
                            .background(Color.buttonColor)
                            .cornerRadius(10)
                            .padding(.top, 0)
                    }
                    
                    Spacer()
                    
                    if (isEditing == false){
                        Button("Sign Out") {
                            self.showAlert = true
                        }   .padding(.vertical, 20)
                            .padding(.horizontal, 90)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .background(Color.buttonColor)
                            .cornerRadius(10)
                            .padding(.top, 0)
                            .padding(.leading, 28)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Sign Out?"),
                                    message: Text("You will be required to log back into your account"),
                                    primaryButton: .default(Text("Sign Out")) {
                                        // Action to perform when OK is tapped
                                        self.navigateToNextView = true
                                    },
                                    secondaryButton: .cancel()
                                )
                            }.frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 30)
                    }
                    else{
                        Text("Sign Out")
                            .padding(.vertical, 20)
                            .padding(.horizontal, 90)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(10)
                            .padding(.top, 0)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    
                    NavigationLink(destination: WelcomeView().navigationBarBackButtonHidden(), isActive: $navigateToNextView) {
                        EmptyView()
                    }.hidden() // Hide the NavigationLink
                    
                }.padding(.bottom, 30)
                
        
        }
        
         
    }
    
    
    
    
    struct ProfileView_Preview: PreviewProvider {
        static var previews: some View {
            ProfileView()
        }
    }
    
    
    
    
    
    
}
