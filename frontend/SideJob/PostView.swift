//
//  PostView.swift
//  SideJob
//
//  Created by Cael Christian on 11/21/23.
//

import SwiftUI

struct PostView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var client: Client
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
        print("post")
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
        
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(newJob)
            client.fetch(verb: "POST", endpoint: "/jobs", auth: true, data: data){  (result: Result<Data, NetworkError>) in
                switch result {
                case .success(_):
                    self.alertMessage = "Job Posted Successfully"
                    self.showAlert = true
                    self.presentationMode.wrappedValue.dismiss()
                case .failure(_):
                    self.alertMessage = "Job Posting Failed"
                    self.showAlert = true
                }
            }
        }
        catch {
            print("Couldn't encode jobs")
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

