import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: StoreOf<AppFeature>

    private let repository: any UserRepository = DefaultUserRepository()

    var body: some View {
        NavigationStack(
            path: Binding(
                get: { store.rootPath },
                set: { store.send(.setRootPath($0)) }
            )
        ) {
            HomeView(
                routesText: store.routesText,
                onPushDetail42: { store.send(.pushDetail42Tapped) },
                onPushDetail42To99: { store.send(.pushDetail42To99Tapped) },
                onPresentSettings: { store.send(.presentSettingsTapped) },
                onReplaceWithHomeDetail77: { store.send(.replaceWithHomeDetail77Tapped) },
                onBackOrPushSettings: { store.send(.backOrPushSettingsTapped) },
                onShowCurrentRoutes: { store.send(.showCurrentRoutesTapped) }
            )
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: DetailRoute.self) { route in
                detailView(id: route.id, context: .root)
                    .navigationTitle("Detail \(route.id)")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .sheet(
            isPresented: Binding(
                get: { store.isSheetPresented },
                set: { store.send(.setSheetPresented($0)) }
            )
        ) {
            modalStack(context: .sheet)
        }
        .fullScreenCover(
            isPresented: Binding(
                get: { store.isFullScreenPresented },
                set: { store.send(.setFullScreenPresented($0)) }
            )
        ) {
            modalStack(context: .fullScreen)
        }
    }

    @ViewBuilder
    private func modalStack(context: NavigationContext) -> some View {
        NavigationStack(
            path: Binding(
                get: { path(for: context) },
                set: { updatePath($0, for: context) }
            )
        ) {
            SettingView(
                context: context,
                onPushDetail7: { store.send(.settingsPushDetail7Tapped(context)) },
                onDismissOrBack: { store.send(.settingsDismissOrBackTapped(context)) }
            )
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: DetailRoute.self) { route in
                detailView(id: route.id, context: context)
                    .navigationTitle("Detail \(route.id)")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    private func detailView(id: String, context: NavigationContext) -> some View {
        DetailView(
            context: context,
            userID: id,
            displayName: repository.displayName(for: id),
            onPushNext: { store.send(.detailPushNextTapped(id: id, context: context)) },
            onBackToHome: { store.send(.detailBackToHomeTapped(context)) },
            onPresentSettingsFullScreen: { store.send(.detailPresentSettingsFullScreenTapped) },
            onBack: { store.send(.detailBackTapped(context)) }
        )
    }

    private func path(for context: NavigationContext) -> [DetailRoute] {
        switch context {
        case .root:
            return store.rootPath
        case .sheet:
            return store.sheetPath
        case .fullScreen:
            return store.fullScreenPath
        }
    }

    private func updatePath(_ path: [DetailRoute], for context: NavigationContext) {
        switch context {
        case .root:
            store.send(.setRootPath(path))
        case .sheet:
            store.send(.setSheetPath(path))
        case .fullScreen:
            store.send(.setFullScreenPath(path))
        }
    }
}

#Preview {
    AppView(
        store: Store(
            initialState: AppFeature.State(),
            reducer: { AppFeature() }
        )
    )
}
