//
//  TimeEntry.swift
//  TogglTempoSync
//
//  Created by Carlos Silva on 02/02/2022.
//

import SwiftUI

struct TimeEntryView: View {
    let description: String?
    let start: Date
    let stop: Date?
    let issueKey: String?
    let duration: String?
    let sync: Bool
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                if let issueKey = issueKey {
                    Text(issueKey)
                        .font(.title3)
                        .bold()
                }
                
                SyncInfoView(serviceName: "Jira Tempo", sync: sync)
                
                Spacer()
                
                if let duration = duration {
                    DurationView(duration: duration)
                } else {
                    RunningAnimView()
                }
            }
            .padding(.bottom, 5)
            HStack{
                if let description = description {
                    Text(description)
                } else {
                    Text("---")
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(UIColor.systemGray5))
        .cornerRadius(5)
    }
}

struct TimeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            TimeEntryView(description: "ER-16282 ER - Title of pending session is wrong in Simulated Exam, Mini Exam", start:Date(), stop: Date(), issueKey: "ER-12345", duration: "22m", sync: true)
            TimeEntryView(description: nil, start: Date(), stop: nil, issueKey: nil, duration: nil, sync: false)
        }
        .padding()
    }
}
