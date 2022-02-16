//
//  RunningAnimView.swift
//  TogglTempoSync
//
//  Created by Carlos Silva on 16/02/2022.
//

import SwiftUI

struct RunningAnimView: View {
    @State var animate = false
    
    var body: some View {
        ZStack {
            Circle().fill(Color.green.opacity(0.35)).frame(width: 25, height: 25).scaleEffect(self.animate ? 1 : 0)
            Circle().fill(Color.green).frame(width: 10, height: 10)
        }
        .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: true), value: animate)
        .onAppear{
            animate.toggle()
        }
    }
}

struct RunningAnimView_Previews: PreviewProvider {
    static var previews: some View {
        RunningAnimView()
    }
}
