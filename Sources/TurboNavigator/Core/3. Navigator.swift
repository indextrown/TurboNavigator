//
//  Navigator.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import UIKit

public final class Navigator<Dependencies, Route: Hashable> {
    public let dependencies: Dependencies
    public let registry: RouteRegistry<Dependencies, Route>
    
    public weak var rootController: UINavigationController?
    public var modalController: UINavigationController?
    
    public let singleStackCoordinator: SingleStackCoordinator<Route>
    
    public init(
        dependencies: Dependencies,
        registry: RouteRegistry<Dependencies, Route>,
        modalController: UINavigationController? = nil,
        singleStackCoordinator: SingleStackCoordinator<Route>
    ) {
        self.dependencies = dependencies
        self.registry = registry
        self.modalController = modalController
        self.singleStackCoordinator = singleStackCoordinator
    }
}
