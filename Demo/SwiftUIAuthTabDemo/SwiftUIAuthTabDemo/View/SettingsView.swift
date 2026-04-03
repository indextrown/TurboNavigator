import SwiftUI
import TurboNavigator

struct SettingsView: View {
    let navigator: Navigator<AppDependencies, MainRoute>
    let sessionStore: SessionStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.largeTitle.weight(.bold))

            Text("현재 탭 구조 안에서도 modal은 정상적으로 동작합니다.")
                .foregroundStyle(.secondary)

            Button("Dismiss") {
                navigator.dismissModal()
            }
            .buttonStyle(.borderedProminent)

            Button("Sign Out") {
                navigator.dismissModal(animated: false)
                sessionStore.signOut()
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(uiColor: .systemBackground))
    }
}
