//
//  Network.swift
//  TogglTempoSync
//
//  Created by Carlos Silva on 02/02/2022.
//

import Foundation
import SwiftUI

enum NetworkError: Error {
    case generic
    case missingUrl
}

class Network {
    func getJiraUser() async throws -> JiraUser {
        let auth = await NetworkAuth().getJiraAuthHeader()
        guard let url = URL(string: "https://beckeredu.atlassian.net/rest/api/3/myself") else { throw NetworkError.missingUrl }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(auth, forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.generic }
        do {
            let decodedData = try JSONDecoder().decode(JiraUser.self, from: data)
            return decodedData
        } catch {
            print(String(describing: error))
            fatalError(error.localizedDescription)
        }
    }
    
    func getTogglEntries(date: Date) async throws -> TogglTimeEntries {
        let auth = await NetworkAuth().getTogglAuthHeader()
        
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let startDate = iso8601DateFormatter.string(from: date.startOfDay)
        let endDate = iso8601DateFormatter.string(from: date.endOfDay)
        guard let url = URL(string: "https://api.track.toggl.com/api/v9/me/time_entries?start_date=\(startDate)&end_date=\(endDate)") else { throw NetworkError.missingUrl }
                
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(auth, forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.generic;
        }
        do {
            let decodedData = try JSONDecoder().decode(TogglTimeEntries.self, from: data)
            return decodedData.reversed()
        } catch {
            print(String(describing: error))
            fatalError(error.localizedDescription)
        }
    }
    
    func putStopToggleTimeEntry(timeEntryId: Int) async throws -> Void {
        let auth = await NetworkAuth().getTogglAuthHeader()
        guard let url = URL(string: "https://api.track.toggl.com/api/v9/time_entries/\(timeEntryId)/stop") else { throw NetworkError.missingUrl }
                
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(auth, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "PUT"
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.generic }
    }
    
    func getTempoEntries(date: Date) async throws -> TempoTimeEntries {
        let auth = await NetworkAuth().getTempoAuthHeader()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let url = URL(string: "https://api.tempo.io/core/3/worklogs?from=\(dateFormatter.string(from: date))&to=\(dateFormatter.string(from: date))") else { throw NetworkError.missingUrl }
                
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(auth, forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.generic;
        }
        do {
            let decodedData = try JSONDecoder().decode(TempoTimeEntries.self, from: data)
            return decodedData
        } catch {
            print(String(describing: error))
            fatalError(error.localizedDescription)
        }
    }
    
    func postTimeEntries(payload: TempoPayload) async throws {
        let auth = await NetworkAuth().getTempoAuthHeader()
        guard let url = URL(string: "https://api.tempo.io/core/3/worklogs") else { throw NetworkError.missingUrl }
        let jsonPayload = try JSONEncoder().encode(payload)
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(auth, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonPayload
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.generic;
        }
    }
}
