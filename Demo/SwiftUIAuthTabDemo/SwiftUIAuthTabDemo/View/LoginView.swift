import SwiftUI
import TurboNavigator

struct LoginView: View {
    let navigator: Navigator<AppDependencies, AuthRoute>
    let sessionStore: SessionStore

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()

            Text("Login")
                .font(.largeTitle.weight(.bold))

            Text("여기서는 탭바가 없습니다. 로그인 성공 시 `sessionStore.phase`가 `.signedIn`으로 바뀌고, 앱 루트가 `TabNavigationContainer`로 교체됩니다.")
                .foregroundStyle(.secondary)

            Button {
                sessionStore.signIn()
            } label: {
                Text("Sign In And Show Tabs")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)

            authFlowCard

            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private var authFlowCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Why This Works")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text("로그인 화면에서 탭 화면을 push하지 않고, 앱의 최상위 컨테이너를 교체합니다.")
            Text("그래서 로그인 전 스택과 로그인 후 탭 구조가 섞이지 않습니다.")
        }
        .font(.footnote)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }
}
