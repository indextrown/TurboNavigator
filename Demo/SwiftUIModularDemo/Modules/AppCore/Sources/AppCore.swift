@_exported import TurboNavigator

public struct AppDependencies {
    public let userRepository: any UserRepository

    public init(userRepository: any UserRepository) {
        self.userRepository = userRepository
    }
}

public protocol UserRepository {
    func displayName(for id: String) -> String
}

public struct DefaultUserRepository: UserRepository {
    public init() {}

    public func displayName(for id: String) -> String {
        "SwiftUI User \(id)"
    }
}

extension AppDependencies: PreviewDependencies {
    public static var preview: Self {
        .init(userRepository: DefaultUserRepository())
    }
}

public enum AppRoute: Hashable {
    case home
    case detail(id: String)
    case settings
}
