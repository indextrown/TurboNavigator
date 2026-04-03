import SwiftUI

struct SplashView: View {
    @ObservedObject var sessionStore: SessionStore

    var body: some View {
        VStack(spacing: 18) {
            Spacer()

            ProgressView()
                .controlSize(.large)

            Text("세션 확인 중")
                .font(.title2.weight(.bold))

            Text("앱 루트에서 로그인 상태를 확인한 뒤, 로그인 화면 또는 탭 루트를 선택합니다.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 6) {
                Text("domain: \(sessionStore.storageDomain)")
                Text("stored value: \(sessionStore.persistedValueDescription)")
            }
            .font(.system(.footnote, design: .monospaced))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemBackground))
            )

            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}
