//
//  HomeView.swift
//  SampleApp
//
//  Created by 김동현 on 3/31/26.
//

import SwiftUI
import TurboNavigator

struct HomeView: View {
    let naviagtor: Navigator<AppDependencies, AppRoute>
    var body: some View {
        Text("\(String(describing: Self.self))")
    }
}

#Preview {
    HomeView(naviagtor: .preview)
}
