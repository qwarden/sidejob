//
//  JobView.swift
//  SideJob
//
//  Created by luke brown on 10/30/23.
//

import SwiftUI



struct JobView: View {
    let job: Job
    
    var body: some View {
        // Vertical stack for job content
        VStack(alignment: .leading, spacing: 10) {
            // Job title
            Text(job.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding([.top, .horizontal])
            
            // Job description
            Text(job.description)
                .font(.body)
                .foregroundColor(.secondary)
                .padding([.bottom, .horizontal])
            
            // Pay information
            HStack {
                Text(job.formattedPay)
                Text(job.payType)
            }
            .padding(.horizontal)
            
            // Job location
            Text(job.location)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding([.bottom, .horizontal])
            
            // Navigation link to the details view
            NavigationLink(destination: DetailsView(job: job)) {
                Text("View Details")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding([.bottom, .horizontal])
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
