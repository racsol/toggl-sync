//
//  SyncInfoView.swift
//  TogglTempoSync
//
//  Created by Carlos Silva on 16/02/2022.
//

import SwiftUI

struct SyncInfoView: View {
    let serviceName: String
    let sync: Bool
    var body: some View {
        HStack{
            Image(systemName: "checkmark.icloud.fill")
                .foregroundColor(sync ? .green : .red)
            Text("Jira Tempo")
                .font(.caption2)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color(sync ? UIColor.green : UIColor.red), lineWidth: 1)
        )
    }
}

struct SyncInfoView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            SyncInfoView(serviceName: "Jira Tempo", sync: true)
            SyncInfoView(serviceName: "Toogl", sync: false)
        }
    }
}
