//
//  NavigatorDebugSnapshot.swift
//  TurboNavigator
//
//  Created by 김동현 on 5/28/26.
//

import Foundation
import UIKit

public enum NavigatorDebugActiveTarget: Equatable {
    case none
    case root
    case tab(tag: Int?)
    case modal
}

public struct NavigatorDebugSnapshot: Equatable {
    public let activeTarget: NavigatorDebugActiveTarget
    public let rootRoutes: [AnyHashable]
    public let tabRoutes: [Int: [AnyHashable]]
    public let modalRoutes: [AnyHashable]

    public init(
        activeTarget: NavigatorDebugActiveTarget,
        rootRoutes: [AnyHashable],
        tabRoutes: [Int: [AnyHashable]],
        modalRoutes: [AnyHashable]
    ) {
        self.activeTarget = activeTarget
        self.rootRoutes = rootRoutes
        self.tabRoutes = tabRoutes
        self.modalRoutes = modalRoutes
    }
}

public extension Navigator {

    func debugSnapshot() -> NavigatorDebugSnapshot {
        NavigatorDebugSnapshot(
            activeTarget: debugActiveTarget(),
            rootRoutes: singleStackCoordinator.currentRoutes(controller: rootController),
            tabRoutes: debugTabRoutes(),
            modalRoutes: singleStackCoordinator.currentRoutes(controller: modalController)
        )
    }

    func debugStackDescription() -> String {
        debugSnapshot().description(orderedTabTags: tabCoordinator.debugOrderedTabTags())
    }

    func printStacks() {
        Swift.print(debugStackDescription())
    }

    private func debugActiveTarget() -> NavigatorDebugActiveTarget {
        if modalController != nil {
            return .modal
        }

        if tabCoordinator.currentNavigationController != nil {
            return .tab(tag: tabCoordinator.currentTag)
        }

        if rootController != nil {
            return .root
        }

        return .none
    }

    private func debugTabRoutes() -> [Int: [AnyHashable]] {
        var routesByTag: [Int: [AnyHashable]] = [:]

        for (tag, controller) in tabCoordinator.tabCoordinators {
            routesByTag[tag] = singleStackCoordinator.currentRoutes(controller: controller)
        }

        return routesByTag
    }
}

private extension TabCoordinator {

    func debugOrderedTabTags() -> [Int] {
        let remainingTags = tabCoordinators.keys
            .filter { !orderedTags.contains($0) }
            .sorted()

        return orderedTags + remainingTags
    }
}

private extension NavigatorDebugSnapshot {

    func description(orderedTabTags: [Int]) -> String {
        var lines: [String] = [
            "TurboNavigator Stack Dump",
            "Active: \(activeTarget.description)",
            "",
            "Root: \(rootRoutes.routeListDescription)"
        ]

        lines.append("Tabs:")

        if orderedTabTags.isEmpty {
            lines.append("  none")
        } else {
            for tag in orderedTabTags {
                lines.append("  [\(tag)]: \((tabRoutes[tag] ?? []).routeListDescription)")
            }
        }

        lines.append("Modal: \(modalRoutes.routeListDescription)")

        return lines.joined(separator: "\n")
    }
}

private extension NavigatorDebugActiveTarget {

    var description: String {
        switch self {
        case .none:
            return "none"
        case .root:
            return "root"
        case let .tab(tag):
            if let tag {
                return "tab(\(tag))"
            }
            return "tab"
        case .modal:
            return "modal"
        }
    }
}

private extension Array where Element == AnyHashable {

    var routeListDescription: String {
        guard !isEmpty else { return "[]" }
        return "[" + map { String(describing: $0) }.joined(separator: ", ") + "]"
    }
}
