//
//  HomeView.swift
//  SampleApp
//
//  Created by 김동현 on 3/31/26.
//

import SwiftUI
import TurboNavigator

struct HomeView: View {
    let navigator: Navigator<AppDependencies, AppRoute>
    var body: some View {
        VStack {
            Text("Home")
                .font(.largeTitle)
            
            Button {
                navigator.push(.detail(id: "TestId"))
            } label: {
                Text("Push")
            }
            
            Button {
                navigator.present(.detail(id: "TestId"))
            } label: {
                Text("Sheet")
            }
        }
    }
}

#Preview {
    HomeView(navigator: .preview)
}
