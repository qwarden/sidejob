//
//  ProfileView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/13/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ProfilePictureView()
        //abViewDemo()
    }
}


// PROFILE PIC
struct ProfilePictureView: View {
    //@Binding var imageName: String
    var body: some View {
        Image(systemName: "person.circle")
        .resizable()
        .scaledToFit()
        .clipShape(Circle())
    }
}




#Preview {
    ProfileView()
}
