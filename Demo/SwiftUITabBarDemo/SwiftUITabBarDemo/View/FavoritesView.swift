import SwiftUI
import TurboNavigator

struct FavoritesView: View {
    let navigator: Navigator<AppDependencies, AppRoute>

    var body: some View {
        DemoScreen(
            title: "Favorites Tab",
            message: "세 번째 탭입니다. 탭 이동과 push 흐름을 가장 단순한 형태로 보여줍니다.",
            items: [
                .init(title: "즐겨찾기 화면", subtitle: "저장해둔 화면 진입점 예시입니다.", systemImage: "star.fill"),
                .init(title: "중요 문서", subtitle: "핀 처리된 항목이 리스트에 보이는 모습입니다.", systemImage: "pin.fill"),
                .init(title: "자주 쓰는 설정", subtitle: "반복 진입하는 메뉴를 별도 보관한 예시입니다.", systemImage: "folder.fill")
            ],
            primaryTitle: "Open Favorites Detail",
            primaryAction: {
                navigator.push(.detail(title: "Favorite Item"))
            },
            secondaryTitle: "Go To Settings Tab",
            secondaryAction: {
                navigator.switchTab(tag: 3)
            }
        )
    }
}
