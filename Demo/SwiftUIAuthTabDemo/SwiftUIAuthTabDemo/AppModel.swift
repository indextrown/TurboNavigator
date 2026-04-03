import Foundation
import SwiftUI

enum SessionPhase {
    case checking
    case signedOut
    case signedIn
}

struct AppDependencies {
    let sessionStore: SessionStore
    let profileRepository: ProfileRepository
}

protocol ProfileRepository {
    func profile(for id: String) -> UserProfile
}

struct UserProfile {
    let id: String
    let name: String
    let bio: String
}

struct DefaultProfileRepository: ProfileRepository {
    func profile(for id: String) -> UserProfile {
        UserProfile(
            id: id,
            name: id == "me" ? "Turbo User" : "Friend \(id)",
            bio: id == "me"
                ? "로그인 이후 탭 루트에서 프로필 탭을 관리합니다."
                : "각 탭은 독립적인 navigation stack을 가집니다."
        )
    }
}

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var phase: SessionPhase = .checking

    private let defaults: UserDefaults
    private let authKey = "SwiftUIAuthTabDemo.isLoggedIn"
    let storageDomain: String

    init(defaults: UserDefaults? = nil) {
        let domain = Bundle.main.bundleIdentifier ?? "SwiftUIAuthTabDemo.debug"
        self.storageDomain = domain
        self.defaults = defaults ?? UserDefaults(suiteName: domain) ?? .standard
    }

    func restoreSession() async {
        try? await Task.sleep(for: .milliseconds(700))
        phase = isPersistedLogin ? .signedIn : .signedOut
    }

    func signIn() {
        defaults.set(true, forKey: authKey)
        defaults.synchronize()
        phase = .signedIn
    }

    func signOut() {
        defaults.removeObject(forKey: authKey)
        defaults.synchronize()
        phase = .signedOut
    }

    var persistedValueDescription: String {
        if let value = defaults.object(forKey: authKey) {
            return String(describing: value)
        }
        return "nil"
    }

    private var isPersistedLogin: Bool {
        (defaults.object(forKey: authKey) as? Bool) ?? false
    }
}
