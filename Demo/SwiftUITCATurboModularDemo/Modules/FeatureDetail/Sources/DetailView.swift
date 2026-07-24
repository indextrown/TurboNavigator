import AppCore
import DemoDesignSystem
import SwiftUI

public struct DetailView: View {
    private let store: StoreOf<DetailFeature>

    public init(store: StoreOf<DetailFeature>) {
        self.store = store
    }

    public var body: some View {
        DemoScreen(
            eyebrow: "FeatureDetail / TCA",
            title: "User \(store.userID)",
            summary: "연관값 route를 Feature state로 변환하고 다음 전환은 다시 TCA action으로 요청합니다.",
            accent: .blue
        ) {
            VStack(spacing: 12) {
                DemoInfoCard(
                    title: "Route payload",
                    value: "id: \(store.userID)",
                    tint: .blue
                )

                DemoInfoCard(
                    title: "Repository output",
                    value: store.displayName,
                    tint: .teal
                )
            }

            VStack(spacing: 12) {
                DemoActionButton(
                    "Push Next Detail",
                    subtitle: "현재 ID에서 다음 Detail route를 만듭니다.",
                    systemImage: "arrow.right.square.fill",
                    tint: .blue
                ) {
                    store.send(.pushNextTapped)
                }

                DemoActionButton(
                    "Back To Home",
                    subtitle: "route 기준으로 Home 화면까지 돌아갑니다.",
                    systemImage: "house.circle.fill",
                    tint: .orange
                ) {
                    store.send(.backToHomeTapped)
                }

                DemoActionButton(
                    "Present Settings Full Screen",
                    subtitle: "별도 modal stack에서 Settings Feature를 실행합니다.",
                    systemImage: "rectangle.inset.filled.and.person.filled",
                    tint: .teal
                ) {
                    store.send(.presentSettingsFullScreenTapped)
                }

                DemoActionButton(
                    "Back",
                    subtitle: "현재 활성 stack에서 한 단계 뒤로 이동합니다.",
                    systemImage: "chevron.backward.circle.fill",
                    tint: .gray
                ) {
                    store.send(.backTapped)
                }
            }
        }
    }
}

#Preview {
    DetailView(
        store: Store(
            initialState: DetailFeature.State(
                userID: "42",
                displayName: "Modular User 42"
            )
        ) {
            DetailFeature()
        }
    )
}
