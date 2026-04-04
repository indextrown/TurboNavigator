import SwiftUI
import TurboNavigator

struct SettingsView: View {
    let navigator: Navigator<AppDependencies, AppRoute>

    var body: some View {
        DemoScreen(
            title: "Settings Tab",
            message: "네 번째 탭입니다. 다시 첫 탭으로 돌아가거나 설정 상세 화면을 열 수 있습니다.",
            items: [
                .init(title: "알림 설정", subtitle: "푸시와 배지 옵션 같은 항목 예시입니다.", systemImage: "bell.badge.fill"),
                .init(title: "화면 모드", subtitle: "테마나 표시 옵션을 담는 샘플입니다.", systemImage: "circle.lefthalf.filled"),
                .init(title: "계정 관리", subtitle: "프로필과 보안 설정으로 이어지는 예시입니다.", systemImage: "person.crop.circle")
            ],
            primaryTitle: "Open Settings Detail",
            primaryAction: {
                navigator.push(.detail(title: "Settings Detail"))
            },
            secondaryTitle: "Back To Home Tab",
            secondaryAction: {
                navigator.switchTab(tag: 0)
            }
        )
    }
}
