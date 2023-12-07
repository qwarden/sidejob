//
//  EditPostView.swift
//  SideJob
//
//  Created by Quimby Warden on 12/6/23.
//

import SwiftUI

struct EditPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var client: Client
    @EnvironmentObject private var locationObject: LocationManager
    
    var job: Job

    @State private var title: String
    @State private var description: String
    @State private var payAmount: String
    @State private var location: String
    @State private var useCurrentLocation = false
    @State private var currentZipCode: String?
    @State private var payType: String
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @State private var lastValidPayAmount: String = ""
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        formatter.alwaysShowsDecimalSeparator = true
        return formatter
    }()
    

    init(job: Job) {
        self.job = job
        _title = State(initialValue: job.title)
        _description = State(initialValue: job.description)
        _payAmount = State(initialValue: String(job.payAmount))
        _location = State(initialValue: job.location)
        _payType = State(initialValue: job.payType)
    }

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
                
                Button("Update Job") {
                    updateJob()
                }
            }
            .navigationBarTitle("Update Job")
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func updateJob() {
        guard !title.isEmpty, !description.isEmpty, !location.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }

        guard let payAmountDouble = Double(payAmount) else {
            alertMessage = "Invalid pay amount."
            showAlert = true
            return
        }
        
        // Update the job object
        let updatedJob = SendJob(title: title, description: description,
                             payAmount: payAmountDouble, location: location, payType: payType)
        
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(updatedJob)
            client.fetch(verb: "PATCH", endpoint: "/jobs/\(job.id)", auth: true, data: data) { (result: Result<Data, NetworkError>) in
                switch result {
                case .success(_):
                    self.alertTitle = "Success"
                    self.alertMessage = "Job Updated Successfully"
                    self.showAlert = true
                    self.presentationMode.wrappedValue.dismiss()
                case .failure(_):
                    self.alertTitle = "Error"
                    self.alertMessage = "Job Update Failed"
                    self.showAlert = true
                }
            }
        }
        catch {
            self.alertTitle = "Error"
            self.alertMessage = "Job Update Failed"
            self.showAlert = true
            print("Couldn't encode job")
        }
    }

    func getCurrentLocationZipCode() {
        locationObject.getLocationZipCode() { zipCode in
            if let zipCode = zipCode {
                DispatchQueue.main.async {
                    self.currentZipCode = zipCode
                    if useCurrentLocation {
                        self.location = zipCode
                    }
                }
            }
        }
    }
}
