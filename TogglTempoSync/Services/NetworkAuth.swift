//
//  NetworkAuth.swift
//  TogglTempoSync
//
//  Created by Carlos Silva on 08/02/2022.
//

import Foundation
import SwiftUI

class NetworkAuth {
    @ObservedObject private var settingsStore = SettingsStore()
    
    func getTogglAuthHeader() -> String {
        let token = "\(settingsStore.settings.togglKey):api_token".toBase64()
        return "Basic \(token)"
    }
    
    func getTempoAuthHeader() -> String {
        return "Bearer \(settingsStore.settings.tempoKey)"
    }
    
    func getJiraAuthHeader() -> String {
        let token = "\(settingsStore.settings.jireUsername):\(settingsStore.settings.jiraKey)".toBase64()
        return "Basic \(token)";
    }
}
