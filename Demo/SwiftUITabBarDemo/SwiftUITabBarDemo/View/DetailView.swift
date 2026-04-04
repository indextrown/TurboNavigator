import SwiftUI
import TurboNavigator

struct DetailView: View {
    let navigator: Navigator<AppDependencies, AppRoute>
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.largeTitle.weight(.bold))

            Text("각 탭에서 같은 detail route 패턴으로 화면을 push 할 수 있는 예제입니다.")
                .foregroundStyle(.secondary)

            Button("Back") {
                navigator.back()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(uiColor: .systemBackground))
    }
}
