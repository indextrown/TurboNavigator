import SwiftUI
import TurboNavigator

struct SplashView: View {
    let navigator: Navigator<AppDependencies, AppRoute>
    let sessionStore: SessionStore

    @State private var didStart = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            ProgressView()
                .controlSize(.large)

            Text("세션 확인 중")
                .font(.title2.weight(.bold))

            Text("앱 시작 시 로그인 여부를 확인한 뒤 첫 화면을 분기합니다.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 6) {
                Text("domain: \(sessionStore.storageDomain)")
                Text("stored value: \(sessionStore.persistedValueDescription)")
            }
            .font(.system(.footnote, design: .monospaced))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
        .task {
            guard !didStart else { return }
            didStart = true

            let isLoggedIn = await sessionStore.restoreSession()
            navigator.replace(with: isLoggedIn ? [.home] : [.login], animated: false)
        }
    }
}

#Preview {
    SplashView(
        navigator: .preview,
        sessionStore: SessionStore()
    )
}
