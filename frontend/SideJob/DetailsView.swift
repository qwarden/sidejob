//
//  DetailsView.swift
//  SideJob
//
//  Created by Lars Jensen on 10/17/23.
//

import SwiftUI

struct DetailsView: View {
    let job: Job

    var body: some View {
        VStack {
            Text("Title: \(job.title)")
                .padding(.bottom, 70)
            Text("Description: \(job.description)")
                .padding(5)
            Text("Price: \(job.price)$ per hour")
                .padding(5)
            Text("Posted By: \(job.postedBy)")
                .padding(5)
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.7, green: 0.8, blue: 1.0))
        .foregroundColor(Color.black)
        .cornerRadius(5)
        .padding(10)
    }
}

/*struct DetailsView_Preview: PreviewProvider {
    static var previews: some View {
        DetailsView(job: )
    }
}

*/
