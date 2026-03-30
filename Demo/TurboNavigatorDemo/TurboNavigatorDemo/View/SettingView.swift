//
//  SettingView.swift
//  TurboNavigatorDemo
//
//  Created by 김동현 on 3/31/26.
//

import SwiftUI
import TurboNavigator

struct SettingView: View {
    let navigator: Navigator<AppDependencies, AppRoute>
    @State private var routeSnapshot = ""
    
    var body: some View {
        ScrollView {
          VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
              .font(.title.bold())

            Text("탭 루트나 modal 루트에서 back 동작 차이를 확인하기 좋다.")
              .foregroundStyle(.secondary)

            section("Navigation") {
              demoButton("Dismiss Or Back") {
                navigator.back()
              }

              demoButton("Push Detail 7") {
                navigator.push(.detail(id: "7"))
              }

              demoButton("Replace With Home") {
                navigator.replace(with: [.home])
              }

              demoButton("Show Current Routes") {
                routeSnapshot = navigator.currentRoutes()
                  .map { String(describing: $0) }
                  .joined(separator: " -> ")
              }

              if !routeSnapshot.isEmpty {
                Text(routeSnapshot)
                  .font(.footnote.monospaced())
                  .foregroundStyle(.secondary)
              }
            }

            section("Tab") {
              demoButton("Switch To Home Tab") {
                navigator.switchTab(tag: 0)
              }
            }
          }
          .padding()
        }
    }
}
