import AppCore

@Reducer
public struct DetailFeature {
    @ObservableState
    public struct State: Equatable, Sendable {
        public let userID: String
        public let displayName: String

        public init(userID: String, displayName: String) {
            self.userID = userID
            self.displayName = displayName
        }
    }

    public enum Action: Equatable, Sendable {
        case pushNextTapped
        case backToHomeTapped
        case presentSettingsFullScreenTapped
        case backTapped
    }

    @Dependency(\.demoNavigation) private var navigation

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .pushNextTapped:
                let nextID = "\(state.userID)-next"
                return .run { [navigation] _ in
                    await navigation.push(.detail(id: nextID))
                }

            case .backToHomeTapped:
                return .run { [navigation] _ in
                    await navigation.backTo(.home)
                }

            case .presentSettingsFullScreenTapped:
                return .run { [navigation] _ in
                    await navigation.presentFullScreen(.settings)
                }

            case .backTapped:
                return .run { [navigation] _ in
                    await navigation.back()
                }
            }
        }
    }
}
