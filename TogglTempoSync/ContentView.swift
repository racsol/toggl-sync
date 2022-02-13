//
//  ContentView.swift
//  TogglTempoSync
//
//  Created by Carlos Silva on 02/02/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var selection = 1;
    private var settingsStore = SettingsStore()
    
    var body: some View {
        TabView(selection: $selection) {
            ListView().tabItem {
                Image(systemName: "list.triangle")
                Text("Time Entries")
            }
            .tag(1)
            SettingsView().tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(2)
        }
        .environmentObject(SettingsStore())
        .onAppear{
            Task{
                do {
                    let network = Network()
                    let data = try await network.getJiraUser()
                    print(data)
                } catch {
                    
                }
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
