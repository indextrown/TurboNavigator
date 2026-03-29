//
//  Coordinator.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/29/26.
//

import SwiftUI
import UIKit
import TurboNavigator

// MARK: - UIKit Engine
public final class UIKitCoordinator<R: Router> {
    
    public typealias Path = R.Path
    public typealias Sheet = R.Sheet
    public typealias FullSheet = R.FullSheet
    public typealias Overlay = R.Overlay
    
    public enum RouteEvent {
        case push(Path)
        case pop
        case popToRoot
        case popTo(Path)
        
        case sheet(Sheet)
        case full(FullSheet)
        case overlay(Overlay)
        
        case dismissSheet
        case dismissFull
        case dismissOverlay
    }
    
    private let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    @MainActor
    public func route(_ event: RouteEvent) {
        switch event {
        case .push(let path):
            let view = R.build(path: path)
            let vc = UIHostingController(rootView: view)
            navigationController.pushViewController(vc, animated: true)
            
        case .pop:
            navigationController.popViewController(animated: true)
            
        case .popToRoot:
            navigationController.popToRootViewController(animated: true)
            
        default:
            break
        }
    }
}


/*

@main
struct TurboNavigatorDemoApp: App {
    
    var body: some Scene {
        WindowGroup {
            RootContainerView()
        }
    }
}



struct RootContainerView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UINavigationController {
        
        let nav = UINavigationController()
        
        let coordinator = UIKitCoordinator<MyRouter>(navigationController: nav)
        
        let rootView = ContentView(coordinator: coordinator)
        let rootVC = UIHostingController(rootView: rootView)
        
        nav.setViewControllers([rootVC], animated: false)
        
        return nav
    }
    
    func updateUIViewController(
        _ uiViewController: UINavigationController,
        context: Context
    ) {}
}
*/
