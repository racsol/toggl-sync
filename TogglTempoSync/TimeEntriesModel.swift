//
//  TimeEntriesModal.swift
//  TogglTempoSync
//
//  Created by Carlos Silva on 02/02/2022.
//

import Foundation

struct TimeEntry: Identifiable, Decodable {
    let id: Int
    let start: Date
    let stop: Date?
    let duration: Int
    let description: String?
    let issueKey: String?
    let durationStr: String?
    let running: Bool
    let sync: Bool
}

typealias TimeEntries = [TimeEntry]

@MainActor
class TimeEntriesModel: ObservableObject {
    let network = Network()
    @Published private(set) var timeEntries: TimeEntries = []
    @Published var loading: Bool = false
    @Published var error: Error?
    
    func extractJiraIssueFromString(string: String?) -> String?{
        var jiraIssueKey: String?
        // Official regular expression from atlassian
        // https://confluence.atlassian.com/stashkb/integrating-with-custom-jira-issue-key-313460921.html
        if let match = string?.match("((?<!([A-Z]{1,10})-?)[A-Z]+-\\d+)").first {
            jiraIssueKey = match[0]
        }
        return jiraIssueKey
    }
   
    func reload(date: Date) async {
        do {
            loading = true
            timeEntries = []
            async let togglTask = try network.getTogglEntries(date: date)
            async let tempoTask = try network.getTempoEntries(date: date)
            let (togglTimeEntries, tempoTimeEntries) = try await (togglTask, tempoTask)
            timeEntries = togglTimeEntries.map{ (item) -> TimeEntry in
                let formatter = ISO8601DateFormatter()
                let startDate = formatter.date(from: item.start)
                var stopDate: Date?
                var durationStr: String?
                if let stop = item.stop {
                    stopDate = formatter.date(from: stop)
                    let seconds = stopDate!.timeIntervalSince(startDate!)
                    durationStr = seconds.asString(style: .abbreviated)
                }
                let running = item.duration < 0
                let sync = tempoTimeEntries.results.filter{ tempoItem in
                    tempoItem.description == String(item.id)
                }.count == 1;
                return TimeEntry(id: item.id, start: startDate!, stop: stopDate, duration: item.duration, description: item.description, issueKey: extractJiraIssueFromString(string: item.description), durationStr: durationStr, running: running, sync: sync)
            }
            loading = false
            error = nil
        } catch {
            loading = false
            self.error = error
        }
    }
    
    func sync(date: Date) async {
        loading = true
        var payloads: [TempoPayload] = []
        timeEntries.forEach{ item in
            if let issueKey = item.issueKey, item.running == false, item.sync == false{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm:ss"
                let payload = TempoPayload(issueKey: issueKey, timeSpentSeconds: item.duration, startDate: dateFormatter.string(from: item.start), startTime: timeFormatter.string(from: item.start), description: "\(item.id)", authorAccountId: "557058:98ae1028-1265-4a2c-816e-d9d60e077134")
                payloads.append(payload)
            }
        }
        await withThrowingTaskGroup(of: Void.self) { group in
            for payload in payloads {
                group.addTask {
                    try await self.network.postTimeEntries(payload: payload)
                }
            }
        }
        await reload(date: date)
    }
    
    func getTotalDuration() -> String {
        return Double(timeEntries.map{ time in
            return max(time.duration, 0)
        }.reduce(0, +)).asString(style: .abbreviated)
    }
}
