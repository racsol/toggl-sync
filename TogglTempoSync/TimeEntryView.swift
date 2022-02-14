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
    @State var animate = false
    
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                if let issueKey = issueKey {
                    Text(issueKey)
                        .font(.title3)
                        .bold()
                }
                
                if (sync) {
                    Image(systemName: "checkmark.icloud.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "xmark.icloud.fill")
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                if let duration = duration {
                    DurationView(duration: duration)
                } else {
                    ZStack {
                        Circle().fill(Color.green.opacity(0.35)).frame(width: 25, height: 25).scaleEffect(self.animate ? 1 : 0)
                        Circle().fill(Color.green).frame(width: 10, height: 10)
                    }.animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: true), value: animate)
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
        .onAppear{
            animate.toggle()
        }
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
