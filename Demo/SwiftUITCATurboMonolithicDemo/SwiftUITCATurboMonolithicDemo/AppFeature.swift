import ComposableArchitecture

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var routesText = "Current routes will appear here."
    }

    enum Action: Equatable {
        case pushDetail42Tapped
        case pushDetail42To99Tapped
        case presentSettingsTapped
        case replaceWithHomeDetail77Tapped
        case backOrPushSettingsTapped
        case showCurrentRoutesTapped
        case routesTextUpdated(String)
        case settingsPushDetail7Tapped
        case settingsDismissOrBackTapped
        case detailPushNextTapped(id: String)
        case detailBackToHomeTapped
        case detailPresentSettingsFullScreenTapped
        case detailBackTapped
    }

    let navigatorClient: NavigatorClient

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .pushDetail42Tapped:
            return .run { _ in
                await navigatorClient.pushDetail42()
            }

        case .pushDetail42To99Tapped:
            return .run { _ in
                await navigatorClient.pushDetail42To99()
            }

        case .presentSettingsTapped:
            return .run { _ in
                await navigatorClient.presentSettings()
            }

        case .replaceWithHomeDetail77Tapped:
            return .run { _ in
                await navigatorClient.replaceWithHomeDetail77()
            }

        case .backOrPushSettingsTapped:
            return .run { _ in
                await navigatorClient.backOrPushSettings()
            }

        case .showCurrentRoutesTapped:
            return .run { send in
                let routesText = await navigatorClient.currentRoutesText()
                await send(.routesTextUpdated(routesText))
            }

        case let .routesTextUpdated(text):
            state.routesText = text
            return .none

        case .settingsPushDetail7Tapped:
            return .run { _ in
                await navigatorClient.pushDetail7()
            }

        case .settingsDismissOrBackTapped:
            return .run { _ in
                await navigatorClient.back()
            }

        case let .detailPushNextTapped(id):
            return .run { _ in
                await navigatorClient.pushNextDetail(id)
            }

        case .detailBackToHomeTapped:
            return .run { _ in
                await navigatorClient.backToHome()
            }

        case .detailPresentSettingsFullScreenTapped:
            return .run { _ in
                await navigatorClient.presentSettingsFullScreen()
            }

        case .detailBackTapped:
            return .run { _ in
                await navigatorClient.back()
            }
        }
    }
}
