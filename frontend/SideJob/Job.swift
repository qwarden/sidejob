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
    let deletedAt: Date?
    //let postedByID : Int64
    let payType: String

//    let photo: URL?
    
    var formattedPay: String {
        return String(format: "$%.2f", Double(payAmount) / 100.0)
    }
    
    
    
    // CodingKeys de-serializes the JSON field names from GORM (that we can't rename before sending)
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case createdAt = "CreatedAt"
        case updatedAt = "UpdatedAt"
        //case postedByID = "posted_by_id"
        case payAmount = "pay_amount"
        case payType = "pay_type "
        case deletedAt = "DeletedAt"
        case title = "title"
        case description = "description"
        case location = "location"
    }
}

struct NewJob: Encodable {
    let title: String
    let description: String
    let payAmount: Int64
    let location: String
    let payType: String
}
