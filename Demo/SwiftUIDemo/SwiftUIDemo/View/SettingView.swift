//
//  SettingView.swift
//  SwiftUIDemo
//
//  Created by Codex on 4/1/26.
//

import SwiftUI
import TurboNavigator

struct SettingView: View {
    let navigator: Navigator<AppDependencies, AppRoute>

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.largeTitle.weight(.bold))

            Text("Modal과 stack 동작을 SwiftUI 래핑 환경에서 직접 확인할 수 있습니다.")
                .font(.body)
                .foregroundStyle(.secondary)

            actionButton("Push Detail 7") {
                navigator.push(.detail(id: "7"))
            }

            actionButton("Dismiss Or Back") {
                navigator.back()
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private func actionButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    SettingView(navigator: .preview)
}
