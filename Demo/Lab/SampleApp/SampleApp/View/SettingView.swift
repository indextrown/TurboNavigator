//
//  SettingView.swift
//  SampleApp
//
//  Created by 김동현 on 3/31/26.
//

import SwiftUI
import TurboNavigator

struct SettingView: View {
    let navigator: Navigator<AppDependencies, AppRoute>
    var body: some View {
        VStack {
            Text("Setting")
                .font(.largeTitle)
        }
    }
}

#Preview {
    SettingView(navigator: .preview)
}
