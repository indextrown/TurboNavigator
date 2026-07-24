import AppCore

@Reducer
public struct SettingsFeature {
    @ObservableState
    public struct State: Equatable, Sendable {
        public init() {}
    }

    public enum Action: Equatable, Sendable {
        case pushDetail7Tapped
        case dismissOrBackTapped
    }

    @Dependency(\.demoNavigation) private var navigation

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .pushDetail7Tapped:
                return .run { [navigation] _ in
                    await navigation.push(.detail(id: "7"))
                }

            case .dismissOrBackTapped:
                return .run { [navigation] _ in
                    await navigation.back()
                }
            }
        }
    }
}
