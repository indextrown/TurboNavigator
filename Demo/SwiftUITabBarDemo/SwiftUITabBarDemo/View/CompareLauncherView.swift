import SwiftUI
import TurboNavigator

struct CompareLauncherView: View {
    let navigator: Navigator<AppDependencies, AppRoute>

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Compare Tab")
                .font(.largeTitle.weight(.bold))

            Text("이 탭은 버튼 하나만 두고, 다음 화면에서 SwiftUI 기본 TabView를 띄워 렌더링 차이를 비교하기 위한 용도입니다.")
                .foregroundStyle(.secondary)

            Button("Open SwiftUI Native Tabs") {
                navigator.push(.nativeTabComparison)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(uiColor: .systemBackground))
    }
}
