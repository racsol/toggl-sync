//
//  DurationView.swift
//  TogglTempoSync
//
//  Created by Carlos Silva on 14/02/2022.
//

import SwiftUI

struct DurationView: View {
    let duration: String
    
    var body: some View {
        Text(duration)
            .foregroundColor(.white)
            .padding(4)
            .background(Color(UIColor.tintColor))
            .cornerRadius(5)
    }
}

struct DurationView_Previews: PreviewProvider {
    static var previews: some View {
        DurationView(duration: "10 min")
    }
}
