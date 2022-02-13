//
//  SettingsView.swift
//  TogglTempoSync
//
//  Created by Carlos Silva on 03/02/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @State var togglApiKey: String = ""
    @State var tempoApiKey: String = ""
    @State var jiraApiKey: String = ""
    @State var jiraUsername: String = ""
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("Settings")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)
                Text("Jira Username")
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
                TextField("", text: $jiraUsername)
                    .textFieldStyle(.roundedBorder)
                Text("API keys")
                    .font(.title2)
                    .bold()
                    .padding(.bottom)
                Text("Toggl")
                TextField("", text: $togglApiKey)
                    .textFieldStyle(.roundedBorder)
                Text("Tempo")
                TextField("", text: $tempoApiKey)
                    .textFieldStyle(.roundedBorder)
                Text("Jira")
                TextField("", text: $jiraApiKey)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
        }
        .onChange(of: togglApiKey) { key in
            settingsStore.saveTogglKey(key: key)
        }
        .onChange(of: tempoApiKey) { key in
            settingsStore.saveTempoKey(key: key)
        }
        .onChange(of: jiraApiKey) { key in
            settingsStore.saveJiraKey(key: key)
        }
        .onChange(of: jiraUsername) { key in
            settingsStore.saveJiraUsername(key: key)
        }
        .onAppear(){
            togglApiKey = settingsStore.settings.togglKey
            tempoApiKey = settingsStore.settings.tempoKey
            jiraApiKey = settingsStore.settings.jiraKey
            jiraUsername = settingsStore.settings.jireUsername
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
