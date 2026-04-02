import SwiftUI

struct DetailView: View {
    let userID: String
    let displayName: String
    let onPushNext: () -> Void
    let onBackToHome: () -> Void
    let onPresentSettingsFullScreen: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detail Screen")
                .font(.largeTitle.weight(.bold))

            detailRow("userID", value: userID)
            detailRow("displayName", value: displayName)

            actionButton("Push Next Detail") {
                onPushNext()
            }

            actionButton("Back To Home") {
                onBackToHome()
            }

            actionButton("Present Settings Full Screen") {
                onPresentSettingsFullScreen()
            }

            actionButton("Back") {
                onBack()
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(uiColor: .systemBackground))
    }

    private func detailRow(_ title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
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
    DetailView(
        userID: "42",
        displayName: DefaultUserRepository().displayName(for: "42"),
        onPushNext: {},
        onBackToHome: {},
        onPresentSettingsFullScreen: {},
        onBack: {}
    )
}
