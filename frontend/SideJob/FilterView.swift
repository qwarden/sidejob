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
    @Binding var isFiltering: Bool
    
    @State private var useCurrentLocation = false
    @State private var currentZipCode: String?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location")) {
                    TextField("Enter Zip Code", text: $userZipCode)
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
                
                Section(header: Text("Radius")) {
                    Picker("Select Radius", selection: $radius) {
                        Text("10 miles").tag(10)
                        Text("25 miles").tag(25)
                        Text("50 miles").tag(50)
                        Text("100 miles").tag(100)
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section {
                    Button("Filter Jobs") {
                        if validateInputs() {
                            filteringByLocation = true
                            isFiltering = true
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            showAlert = true
                        }
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .navigationBarTitle("Filter Jobs", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func validateInputs() -> Bool {
        if userZipCode.isEmpty {
            alertMessage = "Zip Code cannot be empty."
            return false
        } else if userZipCode.count != 5 {
            alertMessage = "Zip Code must be 5 digits."
            return false
        }
        return true
    }
    
    func getCurrentLocationZipCode() {
        locationManager.getLocationZipCode() { zipCode in
            if let zipCode = zipCode {
                DispatchQueue.main.async {
                    self.userZipCode = zipCode
                }
            }
        }
    }
}
