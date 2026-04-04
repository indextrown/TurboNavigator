import SwiftUI
import TurboNavigator

struct SearchView: View {
    let navigator: Navigator<AppDependencies, AppRoute>

    var body: some View {
        DemoScreen(
            title: "Search Tab",
            message: "두 번째 탭입니다. 다른 탭으로 이동하거나 디테일 화면을 push 할 수 있습니다.",
            items: [
                .init(title: "SwiftUI", subtitle: "가장 많이 검색된 키워드 예시입니다.", systemImage: "magnifyingglass"),
                .init(title: "TurboNavigator", subtitle: "라이브러리 관련 검색 결과 샘플입니다.", systemImage: "point.3.connected.trianglepath.dotted"),
                .init(title: "Navigation", subtitle: "관련 주제를 리스트로 나열한 예시입니다.", systemImage: "map")
            ],
            primaryTitle: "Open Search Detail",
            primaryAction: {
                navigator.push(.detail(title: "Search Result"))
            },
            secondaryTitle: "Go To Favorites Tab",
            secondaryAction: {
                navigator.switchTab(tag: 2)
            }
        )
    }
}
