import AppCore

@Reducer
public struct HomeFeature {
    @ObservableState
    public struct State: Equatable, Sendable {
        public var routesText: String

        public init(routesText: String = "Current routes will appear here.") {
            self.routesText = routesText
        }
    }

    public enum Action: Equatable, Sendable {
        case pushDetail42Tapped
        case pushDetailSequenceTapped
        case presentSettingsTapped
        case replaceStackTapped
        case backOrPushSettingsTapped
        case showCurrentRoutesTapped
        case routesTextUpdated(String)
    }

    @Dependency(\.demoNavigation) private var navigation

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .pushDetail42Tapped:
                return .run { [navigation] _ in
                    await navigation.push(.detail(id: "42"))
                }

            case .pushDetailSequenceTapped:
                return .run { [navigation] _ in
                    await navigation.pushMany([
                        .detail(id: "42"),
                        .detail(id: "99"),
                    ])
                }

            case .presentSettingsTapped:
                return .run { [navigation] _ in
                    await navigation.present(.settings)
                }

            case .replaceStackTapped:
                return .run { [navigation] _ in
                    await navigation.replace([
                        .home,
                        .detail(id: "77"),
                    ])
                }

            case .backOrPushSettingsTapped:
                return .run { [navigation] _ in
                    await navigation.backOrPush(.settings)
                }

            case .showCurrentRoutesTapped:
                return .run { [navigation] send in
                    let routesText = await navigation.routesDescription()
                    await send(.routesTextUpdated(routesText))
                }

            case let .routesTextUpdated(routesText):
                state.routesText = routesText
                return .none
            }
        }
    }
}
