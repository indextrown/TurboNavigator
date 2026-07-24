import Foundation

public enum AppRoute: Hashable, Sendable {
    case home
    case detail(id: String)
    case settings
}

extension AppRoute: CustomStringConvertible {
    public var description: String {
        switch self {
        case .home:
            return "home"
        case let .detail(id):
            return "detail(\(id))"
        case .settings:
            return "settings"
        }
    }
}
