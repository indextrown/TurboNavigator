import AppCore
import DemoDesignSystem
import SwiftUI

public struct SettingsView: View {
    private let store: StoreOf<SettingsFeature>

    public init(store: StoreOf<SettingsFeature>) {
        self.store = store
    }

    public var body: some View {
        DemoScreen(
            eyebrow: "FeatureSettings / TCA",
            title: "Settings",
            summary: "동일한 Feature가 push stack과 modal stack 어디에서든 같은 reducer로 동작합니다.",
            accent: .teal
        ) {
            DemoInfoCard(
                title: "Module boundary",
                value: "FeatureSettings → AppCore\nAppNavigation → TurboNavigator",
                tint: .teal
            )

            VStack(spacing: 12) {
                DemoActionButton(
                    "Push Detail 7",
                    subtitle: "현재 활성 stack에 Detail Feature를 추가합니다.",
                    systemImage: "person.crop.circle.badge.plus",
                    tint: .teal
                ) {
                    store.send(.pushDetail7Tapped)
                }

                DemoActionButton(
                    "Dismiss Or Back",
                    subtitle: "stack 깊이에 따라 pop 또는 modal dismiss를 수행합니다.",
                    systemImage: "xmark.circle.fill",
                    tint: .gray
                ) {
                    store.send(.dismissOrBackTapped)
                }
            }
        }
    }
}

#Preview {
    SettingsView(
        store: Store(initialState: SettingsFeature.State()) {
            SettingsFeature()
        }
    )
}
