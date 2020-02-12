//
//  UserResponse.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 12/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

// I used QuickType to generate the codable
// MARK: - Users
struct Users: Codable {
    
    // MARK: - Item
    struct Item: Codable {
        let badgeCounts: BadgeCounts
        let accountID: Int
        let isEmployee: Bool
        let lastModifiedDate, lastAccessDate, reputationChangeYear, reputationChangeQuarter: Int
        let reputationChangeMonth, reputationChangeWeek, reputationChangeDay, reputation: Int
        let creationDate: Int
        let userType: UserType
        let userID: Int
        let acceptRate: Int?
        let location: String?
        let websiteURL: String
        let link: String
        let profileImage: String
        let displayName: String

        enum CodingKeys: String, CodingKey {
            case badgeCounts = "badge_counts"
            case accountID = "account_id"
            case isEmployee = "is_employee"
            case lastModifiedDate = "last_modified_date"
            case lastAccessDate = "last_access_date"
            case reputationChangeYear = "reputation_change_year"
            case reputationChangeQuarter = "reputation_change_quarter"
            case reputationChangeMonth = "reputation_change_month"
            case reputationChangeWeek = "reputation_change_week"
            case reputationChangeDay = "reputation_change_day"
            case reputation
            case creationDate = "creation_date"
            case userType = "user_type"
            case userID = "user_id"
            case acceptRate = "accept_rate"
            case location
            case websiteURL = "website_url"
            case link
            case profileImage = "profile_image"
            case displayName = "display_name"
        }
    }

    // MARK: - BadgeCounts
    struct BadgeCounts: Codable {
        let bronze, silver, gold: Int
    }

    enum UserType: String, Codable {
        case moderator = "moderator"
        case registered = "registered"
    }
    
    let items: [Item]
    let hasMore: Bool
    let quotaMax, quotaRemaining: Int

    enum CodingKeys: String, CodingKey {
        case items
        case hasMore = "has_more"
        case quotaMax = "quota_max"
        case quotaRemaining = "quota_remaining"
    }
}
