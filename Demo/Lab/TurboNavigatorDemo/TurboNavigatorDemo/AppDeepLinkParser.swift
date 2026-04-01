//
//  AppDeepLinkParser.swift
//  TurboNavigatorDemo
//
//  Created by Codex on 4/1/26.
//

import Foundation
import TurboNavigator

struct AppDeepLinkParser: DeepLinkParser {
    func parse(url: URL) -> DeepLink<AppRoute>? {
        guard url.scheme == "turbonavigator",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        if components.host == "dynamic.link" {
            return parseStackURL(components: components)
        }

        switch components.host {
        case "home":
            return DeepLink(route: .home, action: .replace)

        case "settings":
            return DeepLink(route: .settings, action: .present(style: .pageSheet))

        case "detail":
            let id = components.queryItems?
                .first(where: { $0.name == "id" })?
                .value

            guard let id, !id.isEmpty else { return nil }
            return DeepLink(route: .detail(id: id), action: .push)

        case "mvvm":
            return DeepLink(route: .mvvmSample, action: .push)

        default:
            return nil
        }
    }

    private func parseStackURL(components: URLComponents) -> DeepLink<AppRoute>? {
        let paths = components.path
            .split(separator: "/")
            .map(String.init)

        let queryItems = components.queryItems ?? []

        func queryValue(_ name: String) -> String? {
            queryItems.first(where: { $0.name == name })?.value
        }

        var routes: [AppRoute] = []
        var detailIndex = 0

        for path in paths {
            switch path {
            case "home":
                routes.append(.home)

            case "settings":
                routes.append(.settings)

            case "mvvm":
                routes.append(.mvvmSample)

            case "detail":
                detailIndex += 1
                let detailKey = "detail\(detailIndex)"
                let fallbackID = detailIndex == 1 ? queryValue("id") : nil
                guard let id = queryValue(detailKey) ?? fallbackID, !id.isEmpty else { return nil }
                routes.append(.detail(id: id))

            default:
                return nil
            }
        }

        guard !routes.isEmpty else { return nil }
        return DeepLink(routes: routes, action: .replace)
    }
}


// legacy
// import Foundation
// import TurboNavigator

// struct AppDeepLinkParser: DeepLinkParser {
//     func parse(url: URL) -> DeepLink<AppRoute>? {
//         guard url.scheme == "turbonavigator",
//               let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
//             return nil
//         }

//         switch components.host {
//         case "home":
//             return DeepLink(route: .home, action: .replace)

//         case "settings":
//             return DeepLink(route: .settings, action: .present(style: .pageSheet))

//         case "detail":
//             let id = components.queryItems?
//                 .first(where: { $0.name == "id" })?
//                 .value

//             guard let id, !id.isEmpty else { return nil }
//             return DeepLink(route: .detail(id: id), action: .push)

//         case "mvvm":
//             return DeepLink(route: .mvvmSample, action: .push)

//         default:
//             return nil
//         }
//     }
// }
