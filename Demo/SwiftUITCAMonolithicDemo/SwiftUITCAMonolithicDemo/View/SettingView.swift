import SwiftUI

struct SettingView: View {
    let context: NavigationContext
    let onPushDetail7: () -> Void
    let onDismissOrBack: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.largeTitle.weight(.bold))

            Text("Modal과 stack 동작을 SwiftUI 래핑 환경에서 직접 확인할 수 있습니다.")
                .font(.body)
                .foregroundStyle(.secondary)

            Text("Presentation: \(context.rawValue)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            actionButton("Push Detail 7") {
                onPushDetail7()
            }

            actionButton("Dismiss Or Back") {
                onDismissOrBack()
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private func actionButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    SettingView(
        context: .sheet,
        onPushDetail7: {},
        onDismissOrBack: {}
    )
}
