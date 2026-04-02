import ComposableArchitecture
import Foundation

protocol UserRepository {
    func displayName(for id: String) -> String
}

struct DefaultUserRepository: UserRepository {
    func displayName(for id: String) -> String {
        "SwiftUI User \(id)"
    }
}

enum NavigationContext: String, Equatable {
    case root
    case sheet
    case fullScreen
}

struct DetailRoute: Hashable, Equatable, Identifiable {
    let id: String
}

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var rootPath: [DetailRoute] = []
        var sheetPath: [DetailRoute] = []
        var fullScreenPath: [DetailRoute] = []
        var isSheetPresented = false
        var isFullScreenPresented = false
        var routesText = "Current routes will appear here."
    }

    enum Action: Equatable {
        case pushDetail42Tapped
        case pushDetail42To99Tapped
        case presentSettingsTapped
        case replaceWithHomeDetail77Tapped
        case backOrPushSettingsTapped
        case showCurrentRoutesTapped
        case setRootPath([DetailRoute])
        case setSheetPath([DetailRoute])
        case setFullScreenPath([DetailRoute])
        case setSheetPresented(Bool)
        case setFullScreenPresented(Bool)
        case settingsPushDetail7Tapped(NavigationContext)
        case settingsDismissOrBackTapped(NavigationContext)
        case detailPushNextTapped(id: String, context: NavigationContext)
        case detailBackToHomeTapped(NavigationContext)
        case detailPresentSettingsFullScreenTapped
        case detailBackTapped(NavigationContext)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .pushDetail42Tapped:
            state.rootPath.append(DetailRoute(id: "42"))
            return .none

        case .pushDetail42To99Tapped:
            state.rootPath.append(contentsOf: [DetailRoute(id: "42"), DetailRoute(id: "99")])
            return .none

        case .presentSettingsTapped:
            state.isSheetPresented = true
            state.sheetPath = []
            return .none

        case .replaceWithHomeDetail77Tapped:
            state.rootPath = [DetailRoute(id: "77")]
            return .none

        case .backOrPushSettingsTapped:
            if state.isSheetPresented {
                state.isSheetPresented = false
                state.sheetPath = []
            } else if state.isFullScreenPresented {
                state.isFullScreenPresented = false
                state.fullScreenPath = []
            } else {
                state.isSheetPresented = true
                state.sheetPath = []
            }
            return .none

        case .showCurrentRoutesTapped:
            state.routesText = Self.routeSummary(from: state)
            return .none

        case let .setRootPath(path):
            state.rootPath = path
            return .none

        case let .setSheetPath(path):
            state.sheetPath = path
            return .none

        case let .setFullScreenPath(path):
            state.fullScreenPath = path
            return .none

        case let .setSheetPresented(isPresented):
            state.isSheetPresented = isPresented
            if !isPresented {
                state.sheetPath = []
            }
            return .none

        case let .setFullScreenPresented(isPresented):
            state.isFullScreenPresented = isPresented
            if !isPresented {
                state.fullScreenPath = []
            }
            return .none

        case let .settingsPushDetail7Tapped(context):
            appendDetail(id: "7", context: context, state: &state)
            return .none

        case let .settingsDismissOrBackTapped(context):
            dismissModal(context: context, state: &state)
            return .none

        case let .detailPushNextTapped(id, context):
            appendDetail(id: "\(id)-next", context: context, state: &state)
            return .none

        case .detailBackToHomeTapped:
            state.rootPath = []
            state.isSheetPresented = false
            state.sheetPath = []
            state.isFullScreenPresented = false
            state.fullScreenPath = []
            return .none

        case .detailPresentSettingsFullScreenTapped:
            state.isFullScreenPresented = true
            state.fullScreenPath = []
            return .none

        case let .detailBackTapped(context):
            popOrDismiss(context: context, state: &state)
            return .none
        }
    }
}

private extension AppFeature {
    static func routeSummary(from state: State) -> String {
        var segments = ["home"]

        segments.append(contentsOf: state.rootPath.map { "detail(\($0.id))" })

        if state.isSheetPresented {
            let sheetRoutes = ["settings"] + state.sheetPath.map { "detail(\($0.id))" }
            segments.append("sheet[\(sheetRoutes.joined(separator: " -> "))]")
        }

        if state.isFullScreenPresented {
            let fullScreenRoutes = ["settings"] + state.fullScreenPath.map { "detail(\($0.id))" }
            segments.append("fullScreen[\(fullScreenRoutes.joined(separator: " -> "))]")
        }

        return segments.joined(separator: " -> ")
    }

    func appendDetail(id: String, context: NavigationContext, state: inout State) {
        let route = DetailRoute(id: id)

        switch context {
        case .root:
            state.rootPath.append(route)
        case .sheet:
            state.sheetPath.append(route)
        case .fullScreen:
            state.fullScreenPath.append(route)
        }
    }

    func popOrDismiss(context: NavigationContext, state: inout State) {
        switch context {
        case .root:
            if !state.rootPath.isEmpty {
                state.rootPath.removeLast()
            }
        case .sheet:
            if !state.sheetPath.isEmpty {
                state.sheetPath.removeLast()
            } else {
                state.isSheetPresented = false
            }
        case .fullScreen:
            if !state.fullScreenPath.isEmpty {
                state.fullScreenPath.removeLast()
            } else {
                state.isFullScreenPresented = false
            }
        }
    }

    func dismissModal(context: NavigationContext, state: inout State) {
        switch context {
        case .root:
            break
        case .sheet:
            state.isSheetPresented = false
            state.sheetPath = []
        case .fullScreen:
            state.isFullScreenPresented = false
            state.fullScreenPath = []
        }
    }
}
