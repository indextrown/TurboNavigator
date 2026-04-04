import SwiftUI
import TurboNavigator

struct HomeView: View {
    let navigator: Navigator<AppDependencies, AppRoute>

    var body: some View {
        DemoScreen(
            title: "Home Tab",
            message: "첫 번째 탭입니다. TurboNavigator의 탭 전환과 push 동작을 같이 볼 수 있어요.",
            items: [
                .init(title: "오늘의 추천", subtitle: "홈 피드에서 가장 먼저 보이는 카드입니다.", systemImage: "sparkles"),
                .init(title: "최근 본 항목", subtitle: "이전에 열어본 화면 목록 예시입니다.", systemImage: "clock.arrow.circlepath"),
                .init(title: "빠른 시작", subtitle: "자주 쓰는 메뉴를 리스트 형태로 보여줍니다.", systemImage: "bolt.fill")
            ],
            primaryTitle: "Open Home Detail",
            primaryAction: {
                navigator.push(.detail(title: "Home Detail"))
            },
            secondaryTitle: "Go To Search Tab",
            secondaryAction: {
                navigator.switchTab(tag: 1)
            }
        )
    }
}
