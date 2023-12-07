//
//  ProfileView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/13/23.
//

import SwiftUI


struct UserUpdate: Codable {
    var name: String
    var email: String
    var about: String
    
    init() {
        self.name = ""
        self.email = ""
        self.about = ""
    }
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
    @State private var showDeleteConfirmation = false
    
    func loadProfile() {
        client.fetch(verb: "GET", endpoint: "/my/profile", auth: true) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let user = try decoder.decode(User.self, from: data)
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
                    else {
                        NavigationLink(
                            destination: MyListingsView(),
                            label: {
                                Text("My Listings").padding(.vertical, 20).padding(.horizontal, 80).font(.system(size: 20))
                            }
                        ).foregroundColor(.white)
                            .background(Color.blue)
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
                            .background(Color.blue)
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
                            .background(Color.gray)
                            .cornerRadius(10)
                            .padding(.top, 0)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    if isEditing {
                        Button("Delete Profile") {
                            self.showDeleteConfirmation = true
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 80)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .alert(isPresented: $showDeleteConfirmation) {
                            Alert(
                                title: Text("Delete Profile?"),
                                message: Text("This action cannot be undone."),
                                primaryButton: .destructive(Text("Delete")) {
                                    deleteProfile()
                                },
                                secondaryButton: .cancel()
                            )
                        }
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
    
    private func deleteProfile() {
        client.fetch(verb: "DELETE", endpoint: "/my/profile", auth: true) { (result: Result<Data, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    client.logout()
                    self.navigateToNextView = true
                case .failure(_):
                    self.showAlert = true
                }
            }
        }
    }
         

    private func updateProfile() {
        if(user.name.isEmpty || user.email.isEmpty){
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
                var update = UserUpdate()
                update.name = user.name
                update.email = user.email
                update.about = user.about
                
                do {
                    let encoder = JSONEncoder()
                    let jsonData = try encoder.encode(update)

                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print("JSON String: \(jsonString)")
                    }
                    
                    client.fetch(verb: "PATCH", endpoint: "/my/profile", auth: true, data: jsonData) {  (result: Result<Data, NetworkError>) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(_):
                                cannotSave = false
                            case .failure(let error):
                                print("Update error: \(error)")
                                cannotSave = true
                            }
                        }
                     }
                } catch {
                    print("Encoding error: \(error)")
                    cannotSave = true
                }
                return
            }
        }
    }
}
