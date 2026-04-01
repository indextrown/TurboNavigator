//
//  DetailView.swift
//  SampleApp
//
//  Created by 김동현 on 4/1/26.
//

import SwiftUI
import TurboNavigator

struct DetailView: View {
    let navigator: Navigator<AppDependencies, AppRoute>
    let userId: String
    
    var body: some View {
        VStack {
            Text("Detail")
                .font(.largeTitle)
            
            Text("userId: \(userId)")
        }
    }
}

#Preview {
    DetailView(navigator: .preview, userId: "123")
}
