import SwiftUI
import TurboNavigator

struct LoginView: View {
    let navigator: Navigator<AppDependencies, AppRoute>
    let sessionStore: SessionStore

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()

            Text("Login")
                .font(.largeTitle.weight(.bold))

            Text("로그인 성공 후에는 `navigator.replace(with: [.home])`로 루트 전체를 교체합니다.")
                .font(.body)
                .foregroundStyle(.secondary)

            Button {
                sessionStore.signIn()
                navigator.replace(with: [.home])
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)

            Text("로그인 상태는 `UserDefaults`에 저장되어서 앱을 다시 켜도 시작 분기가 유지됩니다.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            debugCard

            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private var debugCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Debug")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text("domain: \(sessionStore.storageDomain)")
                .font(.system(.footnote, design: .monospaced))
            Text("stored value: \(sessionStore.persistedValueDescription)")
                .font(.system(.footnote, design: .monospaced))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }
}

#Preview {
    LoginView(
        navigator: .preview,
        sessionStore: SessionStore()
    )
}
