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
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var lastValidPayAmount: String = ""
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.alwaysShowsDecimalSeparator = true
        return formatter
    }()

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
                }
                
                Section(header: Text("Pay")) {
                    Picker("Pay Type", selection: $payType) {
                        Text("Hourly").tag("Hourly")
                        Text("Total").tag("Total")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        Text(currencyFormatter.currencySymbol)
                        TextField("Amount", text: $payAmount)
                            .keyboardType(.decimalPad)
                            .onChange(of: payAmount) { newValue in
                                let filtered = newValue.filter("0123456789.".contains)
                                if filtered != newValue {
                                    payAmount = filtered
                                }
                            }
                    }
                }
                
                Button("Post Job") {
                    postJob()
                }
                
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .navigationBarItems(leading: Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
        
    private func postJob() {
        guard !title.isEmpty, !description.isEmpty, !location.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        let numericString = payAmount.filter("0123456789.".contains)
        guard let payAmountDouble = Double(numericString) else {
            alertMessage = "Invalid pay amount."
            showAlert = true
            return
        }
        
        let newJob = SendJob(title: title, description: description, payAmount: payAmountDouble, location: location, payType: payType)
        
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(newJob)
            client.fetch(verb: "POST", endpoint: "/jobs/", auth: true, data: data) { (result: Result<Data, NetworkError>) in
                switch result {
                case .success(_):
                    self.alertTitle = "Success"
                    self.alertMessage = "Job Posted Successfully"
                    self.showAlert = true
                    self.presentationMode.wrappedValue.dismiss()
                case .failure(_):
                    self.alertTitle = "Error"
                    self.alertMessage = "Job Posting Failed"
                    self.showAlert = true
                }
            }
        }
        catch {
            self.alertTitle = "Error"
            self.alertMessage = "Job Posting Failed"
            self.showAlert = true
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

