//
//  Models.swift
//  TogglTempoSync
//
//  Created by Carlos Silva on 04/02/2022.
//

import Foundation

// Toggl
struct TogglTimeEntry: Identifiable, Decodable {
    let id: Int
    let guid: String
    let wid: Int
    let pid: Int?
    let billable: Bool
    let start: String
    let stop: String?
    let duration: Int
    let description: String?
    let duronly: Bool
    let at: String
    let uid: Int
}

typealias TogglTimeEntries = [TogglTimeEntry]

// Tempo
struct TempoTimeEntries: Codable {
    let welcomeSelf: String
    let metadata: Metadata
    let results: [TempoTimeEntry]
    
    enum CodingKeys: String, CodingKey {
       case welcomeSelf = "self"
       case metadata, results
   }
}

struct Metadata: Codable {
    let count, offset, limit: Int
}

struct TempoTimeEntry: Codable {
    let resultSelf: String
    let tempoWorklogID, jiraWorklogID: Int
    let issue: Issue
    let timeSpentSeconds, billableSeconds: Int
    let startDate, startTime, description: String
    let createdAt, updatedAt: String
    let author: Author
    let attributes: Attributes

    enum CodingKeys: String, CodingKey {
        case resultSelf = "self"
        case tempoWorklogID = "tempoWorklogId"
        case jiraWorklogID = "jiraWorklogId"
        case issue, timeSpentSeconds, billableSeconds, startDate, startTime
        case description = "description"
        case createdAt, updatedAt, author, attributes
    }
}

struct Attributes: Codable {
    let attributesSelf: String
    let values: [String?]
    
    enum CodingKeys: String, CodingKey {
       case attributesSelf = "self"
       case values
   }
}

struct Author: Codable {
    let authorSelf: String
    let accountID, displayName: String

    enum CodingKeys: String, CodingKey {
        case authorSelf = "self"
        case accountID = "accountId"
        case displayName
    }
}

struct Issue: Codable {
    let issueSelf: String
    let key: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case issueSelf = "self"
        case key, id
    }
}

struct TempoPayload: Encodable {
    let issueKey: String
    let timeSpentSeconds: Int
    let startDate: String
    let startTime: String
    let description: String
    let authorAccountId: String
}

struct JiraUser: Codable {
    let jiraUserSelf: String
    let accountId, emailAddress: String
    let avatarUrls: AvatarUrls
    let displayName: String
    let active: Bool
    let timeZone, locale: String
    let groups, applicationRoles: ApplicationRoles
    let expand: String

    enum CodingKeys: String, CodingKey {
        case jiraUserSelf = "self"
        case accountId
        case emailAddress, avatarUrls, displayName, active, timeZone, locale, groups, applicationRoles, expand
    }
}

struct ApplicationRoles: Codable {
    let size: Int
    let items: [String]
}

struct AvatarUrls: Codable {
    let the48X48, the24X24, the16X16, the32X32: String

    enum CodingKeys: String, CodingKey {
        case the48X48 = "48x48"
        case the24X24 = "24x24"
        case the16X16 = "16x16"
        case the32X32 = "32x32"
    }
}
