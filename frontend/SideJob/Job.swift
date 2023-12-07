//
//  Job.swift
//  SideJob
//
//  Created by Cael Christian on 11/15/23.
//

import Foundation

struct Job: Decodable, Identifiable {
    let id: Int
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
    let title: String
    let description: String
    let payType: String
    let payAmount: Double
    let location: String
    let postedByID: Int
    
    var formattedPay: String {
        return String(format: "$%.2f", payAmount)
    }
    
    
    
    // CodingKeys de-serializes the JSON field names from GORM (that we can't rename before sending)
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
        case deletedAt = "DeletedAt"
        case title
        case description
        case payType = "pay_type"
        case payAmount = "pay_amount"
        case location
        case postedByID = "posted_by_id"
    }
}

struct SendJob: Encodable {
    let title: String
    let description: String
    let payAmount: Double
    let location: String
    let payType: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case payType = "pay_type"
        case payAmount = "pay_amount"
        case location
    }
}
