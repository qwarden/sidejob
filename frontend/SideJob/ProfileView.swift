//
//  ProfileView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/13/23.
//

import SwiftUI

extension Color{
    static let buttonColor = Color(red: 60/255, green: 100/255, blue: 150/255)
    static let darkGray = Color(red: 100/255, green: 100/255, blue: 100/255)
    static let lightGray = Color(red: 220/255, green: 230/255, blue: 270/255)
}


struct ProfileView: View {
    @State private var user: User = User()

    @EnvironmentObject var client: Client
    
    @State private var showSaveAlert = false
    @State private var showAlert = false
    @State private var showEditAlert = false
    @State private var navigateToNextView = false
    @State private var isEditing = false
    @State var askToSignOut: Bool = false
    @State private var alertMessage: String = ""
    @State private var cannotSave = false
    
    func loadProfile() {
        client.fetch(verb: "GET", endpoint: "/my/profile", auth: true) { result in
            switch result {
            case .success(let data):
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.user = user
                } catch {
                    print("Decoding error: \(error)")
                }
            case .failure(let error):
                print("Fetch error: \(error)")
            }
        }
    }
    
    //@Binding var imageName: String
    var body: some View {
      
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
                    
                    if (isEditing == false){
                        Button(action: {
                            isEditing = true
                        }) {
                            Text("Edit")
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 30)
                            .font(.system(size: 20))
                            
                    }
                    else{
                        Button(action: {
                            updateProfile()
                            if (cannotSave == false){
                                isEditing = false
                            }
                        }) {
                            Text("Done")
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 30)
                            .font(.system(size: 20))
                        .alert(isPresented: $showEditAlert) {
                            Alert(title: Text("Cannot update profile"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                        
                    }
                    
                    
                }
                
                Text("Name:")
                    .font(.system(size: 20)).padding(.top, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.lightGray)
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                    if (isEditing == false){
                        Text(user.name)
                            .font(.system(size: 20)).foregroundColor(.darkGray)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                    }
                    else{
                        TextField("", text: $user.name)
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
                                .frame(alignment: .leading)
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
                            destination: ListingsView(user: user),
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
                                        client.logout()
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
                            .background(Color.grgay)
                            .cornerRadius(10)
                            .padding(.top, 0)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    NavigationLink(destination: WelcomeView().navigationBarBackButtonHidden(), isActive: $navigateToNextView) {
                        EmptyView()
                    }.hidden()
                    
                    }
                    
                }.padding(.bottom, 30)
            .onAppear {
                loadProfile()
            }
    }
         

    private func updateProfile() {
        if(user.name.isEmpty || user.email.isEmpty || user.about.isEmpty){
            alertMessage = "Please fill in all fields"
            showEditAlert = true
            cannotSave = true
            return
        }
        else {
            if(!user.email.contains("@") || !user.email.contains(".")){
                alertMessage = "Please enter valid email"
                showEditAlert = true
                cannotSave = true
                return
            }
            else{
                cannotSave = false
                return
            }
        }
    }
}
