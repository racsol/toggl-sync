//
//  Settings.swift
//  TogglTempoSync
//
//  Created by Carlos Silva on 07/02/2022.
//

import Foundation

struct Settings: Codable {
    var togglKey: String
    var tempoKey: String
    var jiraKey: String
    var jireUsername: String
}

class SettingsStore: ObservableObject {
    @Published private(set) var settings: Settings  = Settings(togglKey: "", tempoKey: "", jiraKey: "", jireUsername: "")
    static let saveKey = "settingsstore"

    init() {
        if let data = UserDefaults.standard.data(forKey: SettingsStore.saveKey) {
            if let decoded = try? JSONDecoder().decode(Settings.self, from: data) {
                self.settings = decoded
                return
            }
        }
        self.settings = Settings(togglKey: "", tempoKey: "", jiraKey: "", jireUsername: "")
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: SettingsStore.saveKey)
        }
    }
    
    func saveTogglKey(key: String) {
        settings.togglKey = key
        save()
    }
    
    func saveTempoKey(key: String) {
        settings.tempoKey = key
        save()
    }
    
    func saveJiraKey(key: String) {
        settings.jiraKey = key
        save()
    }
    
    func saveJiraUsername(key: String) {
        settings.jireUsername = key
        save()
    }
}

