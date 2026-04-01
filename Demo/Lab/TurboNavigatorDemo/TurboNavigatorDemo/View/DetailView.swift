//
//  DetailView.swift
//  TurboNavigatorDemo
//
//  Created by 김동현 on 3/31/26.
//

import SwiftUI
import TurboNavigator

struct DetailView: View {
    let userID: String
    let repository: UserRepository
    let navigator: Navigator<AppDependencies, AppRoute>
    @State private var routeSnapshot = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Detail")
                    .font(.title.bold())
                
                Text("userID: \(userID)")
                Text("displayName: \(repository.displayName(for: userID))")
            }
        }
    }
}
