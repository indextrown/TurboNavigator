import AppCore
import DemoDesignSystem
import SwiftUI

public struct HomeView: View {
    private let store: StoreOf<HomeFeature>

    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }

    public var body: some View {
        DemoScreen(
            eyebrow: "FeatureHome / TCA",
            title: "Navigation Lab",
            summary: "TCA는 상태와 액션을 관리하고, TurboNavigator는 실제 UIKit 화면 전환을 수행합니다.",
            accent: .orange
        ) {
            DemoInfoCard(
                title: "Active route stack",
                value: store.routesText,
                tint: .orange
            )

            VStack(spacing: 12) {
                DemoActionButton(
                    "Push Detail 42",
                    subtitle: "단일 typed route를 현재 stack에 추가합니다.",
                    systemImage: "arrow.right.circle.fill",
                    tint: .orange
                ) {
                    store.send(.pushDetail42Tapped)
                }

                DemoActionButton(
                    "Push Detail 42 → 99",
                    subtitle: "하나의 TCA action으로 여러 route를 구성합니다.",
                    systemImage: "square.stack.3d.up.fill",
                    tint: .orange
                ) {
                    store.send(.pushDetailSequenceTapped)
                }

                DemoActionButton(
                    "Present Settings",
                    subtitle: "Settings Feature를 modal stack으로 표시합니다.",
                    systemImage: "rectangle.portrait.and.arrow.forward.fill",
                    tint: .teal
                ) {
                    store.send(.presentSettingsTapped)
                }

                DemoActionButton(
                    "Replace With Home → Detail 77",
                    subtitle: "현재 stack 전체를 route 배열로 교체합니다.",
                    systemImage: "arrow.triangle.2.circlepath",
                    tint: .blue
                ) {
                    store.send(.replaceStackTapped)
                }

                DemoActionButton(
                    "Back Or Push Settings",
                    subtitle: "기존 route가 있으면 돌아가고, 없으면 push합니다.",
                    systemImage: "arrow.uturn.backward.circle.fill",
                    tint: .indigo
                ) {
                    store.send(.backOrPushSettingsTapped)
                }

                DemoActionButton(
                    "Refresh Route Snapshot",
                    subtitle: "Navigator의 현재 route를 TCA state에 반영합니다.",
                    systemImage: "waveform.path.ecg.rectangle.fill",
                    tint: .mint
                ) {
                    store.send(.showCurrentRoutesTapped)
                }
            }
        }
    }
}

#Preview {
    HomeView(
        store: Store(
            initialState: HomeFeature.State(
                routesText: "home → detail(42)"
            )
        ) {
            HomeFeature()
        }
    )
}
