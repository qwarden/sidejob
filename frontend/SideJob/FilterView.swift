//
//  FilterView.swift
//  SideJob
//
//  Created by Lars Jensen on 12/4/23.
//

import SwiftUI

struct FilterView: View {
    @Binding var zipCode: String
    @Binding var radius: Int
    @EnvironmentObject private var locationManager: LocationManager
    
    @State private var location: String = ""
    @State private var useCurrentLocation = false
    @State private var currentZipCode: String?
    
    @State private var zipCodeErrorMessage = ""
    @State private var radiusErrorMessage = ""
    @State private var loginErrorMessage = ""
    
    var body: some View {
        Text("Filter Job Locations:").font(.system(size: 24, weight: .bold, design: .default)).foregroundColor(Color(.systemBlue)).padding()
        VStack(spacing: 25) {
            Section(header: Text("Your Location")) {
                TextField("Enter Zip Code", text: $location)
                    .keyboardType(.numberPad)
                
                Toggle("Use Current Location", isOn: $useCurrentLocation)
                    .onChange(of: useCurrentLocation) { newValue in
                        if newValue {
                            getCurrentLocationZipCode()
                        }
                    }
                
                if let currentZipCode = currentZipCode {
                    Text("Current Zip Code: \(currentZipCode)")
                        .foregroundColor(.secondary)
                }
            }
            // Display error if there is one
            if (zipCodeErrorMessage != "") {
                Text(zipCodeErrorMessage).foregroundColor(Color.red)
            }
            
            Picker("Select Radius", selection: $radius) {
                Text("10 miles").tag(10)
                Text("25 miles").tag(25)
                Text("50 miles").tag(50)
                Text("100 miles").tag(100)
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            // button to filter
            NavigationLink(destination: FeedView().navigationBarBackButtonHidden()) {
                Text("Filter")
            }
        }
    }
        
    func getCurrentLocationZipCode() {
        locationManager.getLocationZipCode() { zipCode in
            if let zipCode = zipCode {
                DispatchQueue.main.async {
                    self.location = zipCode
                }
            }
        }
    }
}

//#Preview {
//    FilterView().environmentObject(UserTokens())
//}
