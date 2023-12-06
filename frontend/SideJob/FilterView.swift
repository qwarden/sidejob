//
//  FilterView.swift
//  SideJob
//
//  Created by Lars Jensen on 12/4/23.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @Binding var filteringByLocation: Bool
    @Environment(\.presentationMode) private var presentationMode
    @Binding var userZipCode: String
    @Binding var radius: Int
    
    @State private var location: String = ""
    @State private var useCurrentLocation = false
    @State private var currentZipCode: String?
    
    @State private var zipCodeErrorMessage = ""
    
    var body: some View {
        Text("Filter Job Locations:").font(.system(size: 24, weight: .bold, design: .default)).foregroundColor(Color(.systemBlue)).padding()
        NavigationView {
            VStack(spacing: 25) {
                Section() {
                    HStack() {
                        Text("Enter Zip Code:")
                        TextField("Zip Code", text: $userZipCode)
                            .keyboardType(.numberPad)
                    }
                    Toggle("Use Current Location", isOn: $useCurrentLocation)
                        .onChange(of: useCurrentLocation) { newValue in
                            if newValue {
                                getCurrentLocationZipCode()
                            }
                        }
                    //what the fuck does this do
                    if let currentZipCode = currentZipCode {
                        Text("Current Zip Code: \(currentZipCode)")
                            .foregroundColor(.secondary)
                    }
                }
                // Display error if there is one
                if (zipCodeErrorMessage != "") {
                    Text(zipCodeErrorMessage).foregroundColor(Color.red)
                }
                
                HStack {
                    Text("Radius:")
                    Picker("Select Radius", selection: $radius) {
                        Text("10 miles").tag(10)
                        Text("25 miles").tag(25)
                        Text("50 miles").tag(50)
                        Text("100 miles").tag(100)
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                }
                
                // button to filter
                Button("Filter Jobs") {
                    if (FilterJobValidation()) {
                        filteringByLocation = true
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
            }.padding().padding()
        }
    }
    
    func FilterJobValidation() -> Bool {
        if userZipCode == "" {
            zipCodeErrorMessage = "Zip Code Cannot Be Empty"
            return false
        }
        else if userZipCode.count != 5 {
            zipCodeErrorMessage = "Zip Code Must be 5 Digits"
            return false
        }
        else {
            return true
        }
        
    }
        
    func getCurrentLocationZipCode() {
        locationManager.getLocationZipCode() { zipCode in
            if let zipCode = zipCode {
                DispatchQueue.main.async {
                    userZipCode = zipCode
                }
            }
        }
    }
}
