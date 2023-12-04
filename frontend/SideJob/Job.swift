//
//  Job.swift
//  SideJob
//
//  Created by Cael Christian on 11/15/23.
//

import Foundation

struct Job: Decodable, Identifiable {
    let id: Int
    let createdAt, updatedAt: Date?
    let title : String
    let description : String
    let payAmount: Int64
    let location: String
    let postedByID : Int64
    let payType: String
    
    var formattedPay: String {
        return String(format: "$%.2f", Double(payAmount) / 100.0)
    }
    var formattedPostedDate: String {
            createdAt?.formattedDateString() ?? "N/A"
    }
    var formattedUpdatedDate: String {
            updatedAt?.formattedDateString() ?? "N/A"
    }
    
//    var payUnit: String {
//        switch payType {
//        case "hourly":
//            return "per hour"
//        case "flat":
//            return "total"
//        default:
//            return ""
//        }
//    }
    
    // CodingKeys de-serializes the JSON field names from GORM (that we can't rename before sending)
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
        case title, description, location, postedByID, payType, payAmount
    }
}

struct NewJob: Encodable {
    let title: String
    let description: String
    let payAmount: Int64
    let location: String
    let payType: String
}
extension Date {
    func formattedDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
