public protocol UserRepository: Sendable {
    func displayName(for id: String) -> String
}

public struct DefaultUserRepository: UserRepository {
    public init() {}

    public func displayName(for id: String) -> String {
        "Modular User \(id)"
    }
}
