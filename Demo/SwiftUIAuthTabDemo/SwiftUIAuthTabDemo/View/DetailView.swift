import SwiftUI
import TurboNavigator

struct DetailView: View {
    let navigator: Navigator<AppDependencies, MainRoute>
    let userID: String
    let repository: ProfileRepository

    var body: some View {
        let profile = repository.profile(for: userID)

        VStack(alignment: .leading, spacing: 16) {
            Text("Detail")
                .font(.largeTitle.weight(.bold))

            Text("id: \(profile.id)")
                .font(.system(.body, design: .monospaced))

            Text(profile.name)
                .font(.title2.weight(.semibold))

            Text(profile.bio)
                .foregroundStyle(.secondary)

            Button("Back") {
                navigator.back()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(uiColor: .systemGroupedBackground))
    }
}
