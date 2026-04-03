import SwiftUI
import TurboNavigator

struct ProfileView: View {
    let navigator: Navigator<AppDependencies, MainRoute>
    let sessionStore: SessionStore
    let repository: ProfileRepository

    var body: some View {
        let profile = repository.profile(for: "me")

        VStack(alignment: .leading, spacing: 16) {
            Text(profile.name)
                .font(.largeTitle.weight(.bold))

            Text(profile.bio)
                .foregroundStyle(.secondary)

            Button("Open My Detail") {
                navigator.push(.detail(id: profile.id))
            }
            .buttonStyle(.borderedProminent)

            Button("Back To Feed Tab") {
                navigator.switchTab(tag: 0)
            }
            .buttonStyle(.bordered)

            Button("Sign Out") {
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
