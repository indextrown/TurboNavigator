import SwiftUI

struct HomeView: View {
    let routesText: String
    let onPushDetail42: () -> Void
    let onPushDetail42To99: () -> Void
    let onPresentSettings: () -> Void
    let onReplaceWithHomeDetail77: () -> Void
    let onBackOrPushSettings: () -> Void
    let onShowCurrentRoutes: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("TurboNavigator SwiftUI Demo")
                    .font(.largeTitle.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("SwiftUI bridge 위에서 UIKitDemo와 같은 Navigator 흐름을 확인합니다.")
                    .font(.body)
                    .foregroundStyle(.secondary)

                actionButton("Push Detail 42") {
                    onPushDetail42()
                }

                actionButton("Push Detail 42 -> 99") {
                    onPushDetail42To99()
                }

                actionButton("Present Settings") {
                    onPresentSettings()
                }

                actionButton("Replace With Home -> Detail 77") {
                    onReplaceWithHomeDetail77()
                }

                actionButton("Back Or Push Settings") {
                    onBackOrPushSettings()
                }

                actionButton("Show Current Routes") {
                    onShowCurrentRoutes()
                }

                Text(routesText)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(uiColor: .secondarySystemBackground))
                    )
            }
            .padding(20)
        }
        .background(Color(uiColor: .systemBackground))
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
    HomeView(
        routesText: "home -> detail(42) -> sheet[settings]",
        onPushDetail42: {},
        onPushDetail42To99: {},
        onPresentSettings: {},
        onReplaceWithHomeDetail77: {},
        onBackOrPushSettings: {},
        onShowCurrentRoutes: {}
    )
}
