//
//  PostView.swift
//  SideJob
//
//  Created by Cael Christian on 11/21/23.
//

import SwiftUI

struct PostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var jobService: JobService = JobService.shared
    @EnvironmentObject private var locationObject: LocationManager
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var payAmount: String = ""
    @State private var location: String = ""
    @State private var useCurrentLocation = false
    @State private var currentZipCode: String?
    @State private var payType: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                
                Section(header: Text("Location")) {
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
                    
                    Picker("Pay Type", selection: $payType) {
                        Text("Hourly").tag("Hourly")
                        Text("Total").tag("Total")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    TextField("Pay Amount", text: $payAmount)
                        .keyboardType(.decimalPad)
                    
                    Button("Post Job") {
                        postJob()
                    }
                }
                .navigationBarTitle("Post Job")
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
        
    private func postJob() {
        guard !title.isEmpty, !description.isEmpty, !location.isEmpty else {
            alertMessage = "please fill in all fields."
            showAlert = true
            return
        }
        
        guard let payAmountInt = Int64(payAmount) else {
            alertMessage = "invalid pay amount."
            showAlert = true
            return
        }
        
        let newJob = NewJob(title: title, description: description, payAmount: payAmountInt, location: location, payType: payType)
        jobService.postJob(newJob: newJob) { success in
            DispatchQueue.main.async {
                if success {
                    DispatchQueue.main.async {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    alertMessage = "Failed to post the job."
                    showAlert = true
                }
            }
        }
    }
        
    func getCurrentLocationZipCode() {
        locationObject.getLocationZipCode() { zipCode in
            if let zipCode = zipCode {
                DispatchQueue.main.async {
                    self.location = zipCode
                }
            }
        }
    }
}

