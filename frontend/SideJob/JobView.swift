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
        VStack(alignment: .leading, spacing: 10) {
            Text(job.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding([.top, .horizontal])
            
            Text(job.description)
                .font(.body)
                .foregroundColor(.secondary)
                .padding([.bottom, .horizontal])
            
            HStack {
                Text(job.formattedPay)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text("/ hour")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            Text(job.location)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding([.bottom, .horizontal])
            
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



//struct JobView_Preview: PreviewProvider {
//    static var previews: some View {
//        JobView(job: Job(id: 1, createdAt: Date(), updatedAt: Date(), title: "Lawn Job", description: "Cut my grass", payAmount: 3000,  location: "123 Main St", postedBy: 1))
//    }
//}
