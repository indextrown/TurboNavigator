//
//  Navigator.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import UIKit

/// 사용자가 sheet를 스와이프로 dismiss했을 때
/// `Navigator.modalController` 에 남아 있는 stale 참조를 정리하기 위한 observer입니다.
///
/// `UIAdaptivePresentationControllerDelegate` 를 통해 interactive dismiss 완료 시점을 감지하고
/// 외부에서 주입한 `onDidDismiss` 클로저를 실행합니다.
private final class ModalPresentationObserver: NSObject, UIAdaptivePresentationControllerDelegate {
    var onDidDismiss: (() -> Void)?

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onDidDismiss?()
    }
}

/// `Navigator`는 Route를 입력받아.
/// - Registry를 통해 ViewController를 생성하고
/// - Stack / Modal / Tab Coordinator에 위임하여 화면 전환을 수행합니다.
///
/// - 특징:
///   - Stack / Modal / Tab 네비게이션 통합 관리
///   - Route 기반 ViewController 생성 (Registry 패턴)
///   - 현재 활성 컨트롤러 자동 판단 (Modal > Tab > Root 우선순위)
///   - 단일 API로 다양한 네비게이션 처리 가능
///
/// - Generic:
///   - Dependencies: ViewController 생성 시 필요한 외부 의존성
///   - Route: Hashable한 라우트 타입
///
/// - Architecture:
///   Navigator
///   ├── RouteRegistry (VC 생성)
///   ├── SingleStackCoordinator (push/pop)
///   ├── ModalCoordinator (present/dismiss)
///   └── TabCoordinator (탭 관리)
public final class Navigator<Dependencies, Route: Hashable> {
    
    /// 외부 의존성(DI)
    public let dependencies: Dependencies
    
    /// Route -> ViewController 생성 담당
    public let registry: RouteRegistry<Dependencies, Route>
    
    /// 루트 NavigationController
    public weak var rootController: UINavigationController?
    
    /// 현재 황성 modal NavigationController
    public var modalController: UINavigationController?

    /// 제스처 dismiss 후 stale modal state를 정리하기 위한 observer
    private let modalPresentationObserver = ModalPresentationObserver()
    
    /// Stack 전용 Coordinator
    public let singleStackCoordinator: SingleStackCoordinator<Route>
    
    /// Modal 전용 Coordinator
    public let modalCoordinator: ModalCoordinator<Dependencies, Route>
    
    /// Tab 전용 Coordinator
    public let tabCoordinator: TabCoordinator<Dependencies, Route>
    
    public init(
        dependencies: Dependencies,
        registry: RouteRegistry<Dependencies, Route>,
        modalController: UINavigationController? = nil,
        singleStackCoordinator: SingleStackCoordinator<Route> = .init(),
        modalCoordinator: ModalCoordinator<Dependencies, Route> = .init(),
        tabCoordinator: TabCoordinator<Dependencies, Route> = .init()
    ) {
        self.dependencies = dependencies
        self.registry = registry
        self.modalController = modalController
        self.singleStackCoordinator = singleStackCoordinator
        self.modalCoordinator = modalCoordinator
        self.tabCoordinator = tabCoordinator
        self.modalPresentationObserver.onDidDismiss = { [weak self] in
            self?.modalController = nil
        }
    }
    
    
    /// 현재 Stack 변경이 적용될 NavigationController
    ///
    /// - Priority:
    ///   1. Modal
    ///   2. Tab
    ///   3. Root
    public var activeController: UINavigationController? {
        if let modalController, modalController.presentingViewController != nil {
            return modalController
        }

        return tabCoordinator.currentNavigationController ?? rootController
    }
    
    
    /// 현재 modal이 활성화되어 있는지 여부
    public var isModalActive: Bool {
        return modalController != nil
    }
    
    
    /// modal을 띄운 controller (Tab > Root)
    private var presentationController: UINavigationController? {
        return tabCoordinator.currentNavigationController ?? rootController
    }
    
    
    /// 초기 화면(ViewController 배열)을 생성합니다.
    ///
    /// - Parameter routes: 초기 route 목록
    /// - Returns: 생성된 ViewController 배열
    public func launch(_ routes: [Route]) -> [UIViewController] {
        return registry.build(routes: routes, navigator: self, dependencies: dependencies)
    }
    
    
    /// 현재 활성 stack의 route 목록을 반환합니다.
    public func currentRoutes() -> [AnyHashable] {
        return singleStackCoordinator.currentRoutes(controller: activeController)
    }
}

// MARK: - Push
extension Navigator {
    
    /// 여러 route를 순차적으로 push합니다.
    public func push(
        _ routes: [Route],
        animated: Bool = true
    ) {
        let newControllers = registry.build(
            routes: routes,
            navigator: self,
            dependencies: dependencies
        )
        
        singleStackCoordinator.append(
            viewControllers: newControllers,
            to: activeController,
            animated: animated
        )
    }
    
    
    /// 단일 route를 push합니다.
    /// - Parameters:
    ///   - route: push할 라우트
    ///   - animated: 애니메이션 여부
    public func push(
        _ route: Route,
        animated: Bool = true
    ) {
        push([route], animated: animated)
    }
}


// MARK: - Replace
extension Navigator {
    
    /// 현재 stack을 새로운 route로 교체합니다.
    public func replace(
        with routes: [Route],
        animated: Bool = true
    ) {
        let newControllers = registry.build(
            routes: routes,
            navigator: self,
            dependencies: dependencies
        )
        
        singleStackCoordinator.replace(
            viewControllers: newControllers,
            on: activeController,
            animated: animated
        )
    }
}


// MARK: - Back
extension Navigator {
    
    /// 한 단계 뒤로 이동합니다.
    ///
    /// - Parameter animated: 애니메이션 여부
    ///
    /// - Behavior:
    ///   - stack이 2개 이상 → pop
    ///   - modal 단일 화면 → dismiss
    public func back(animated: Bool = true) {
        guard let activeController else { return }
        
        if activeController.viewControllers.count > 1 {
            activeController.popViewController(animated: animated)
            return
        }
        
        guard modalController === activeController else { return }
        dismissModal(animated: animated)
    }
    
    
    
    /// 네비게이션 스택에서 특정 route에 해당하는 화면까지 pop합니다.
    ///
    /// - Description:
    ///   현재 `UINavigationController` 스택에서 전달된 `route`와 일치하는
    ///   가장 마지막 ViewController를 찾아 해당 화면까지 pop합니다.
    ///   (즉, 그 위에 쌓인 화면들은 모두 제거됩니다)
    ///
    ///   만약 해당 route에 해당하는 ViewController가 스택에 존재하지 않으면
    ///   아무 동작도 수행하지 않습니다.
    ///
    /// - Parameters:
    ///   - route: pop 대상이 되는 route.
    ///            이 route와 매칭되는 마지막 ViewController까지 pop됩니다.
    ///   - animated: pop 애니메이션 여부 (기본값: `true`)
    ///
    /// - Note:
    ///   내부적으로 `SingleStackCoordinator.lastMatchedViewController`를 사용하여
    ///   route에 대응되는 ViewController를 탐색합니다.
    ///
    /// - Important:
    ///   `RouteViewController (AnyRouteIdentifiable)`를 사용하지 않는 경우,
    ///   route 매칭이 정상적으로 동작하지 않을 수 있습니다.
    public func backTo(
        _ route: Route,
        animated: Bool = true
    ) {
        guard let activeController, let target = singleStackCoordinator.lastMatchedViewController(
            route: route, in: activeController) else {
            return
        }
        activeController.popToViewController(target, animated: animated)
    }
    
    
    /// 해당 route가 존재하면 pop, 없으면 push합니다.
    public func backOrPush(
        _ route: Route,
        animated: Bool = true
    ) {
        guard let activeController,
              let target = singleStackCoordinator.lastMatchedViewController(
                route: route,
                in: activeController
              ) else {
            push(route, animated: animated)
            return
        }
        
        activeController.popToViewController(target, animated: animated)
    }
}


// MARK: - Modal
extension Navigator {
    
    /// 여러 route modal stack으로 표시합니다.
    /// - Parameters:
    ///   - routes: 라우트 배열
    ///   - animated: 애니메이션 유무
    ///   - style: 모달 스타일
    public func present(
        _ routes: [Route],
        animated: Bool = true,
        style: ModalPresentationStyle = .automatic
    ) {
        modalController = modalCoordinator.present(
            routes: routes,
            from: presentationController,
            existingModalController: modalController,
            navigator: self,
            animated: animated,
            presentationStyle: style
        )

        modalController?.presentationController?.delegate = modalPresentationObserver
    }
    
    
    /// 단일 rooute modal로 표시합니다
    public func present(
        _ route: Route,
        animated: Bool = true,
        style: ModalPresentationStyle = .automatic
    ) {
        present([route], animated: animated, style: style)
    }
    
    
    /// fullScreen modal 표시 (단일)
    public func presentFullScreen(
        _ route: Route,
        animated: Bool = true
    ) {
        present(route, animated: animated, style: .fullScreen)
    }
    
    
    /// fullScreen modal 표시 (여러 route)
    public func presentFullScreen(
        _ routes: [Route],
        animated: Bool = true
    ) {
        present(routes, animated: animated, style: .fullScreen)
    }
    
    
    /// 현재 modal을 dismiss합니다.
    public func dismissModal(animated: Bool = true) {
        modalCoordinator.dismiss(modalController: modalController, animated: animated) { [weak self] in
            self?.modalController?.presentationController?.delegate = nil
            self?.modalController = nil
        }
    }
}


// MARK: - Tab
extension Navigator {
    /// 특정 탭으로 이동합니다.
    public func switchTab(tag: Int, popToRootIfSelected: Bool = true) {
        tabCoordinator.switchTab(tag: tag, popToRootIfSelected: popToRootIfSelected)
    }
}


/**
 MARK: - Example

 enum AppRoute: Hashable {
   case home
   case detail(id: String)
   case settings
 }

 // MARK: - Navigator 생성
 let navigator = Navigator<AppDependencies, AppRoute>(
   dependencies: AppDependencies()
 )

 let navController = UINavigationController()
 navigator.rootController = navController

 // MARK: - 초기 화면 설정
 let rootVCs = navigator.launch([.home])
 navController.setViewControllers(rootVCs, animated: false)

 // MARK: - Push
 navigator.push(.detail(id: "42"))

 // MARK: - 여러 화면 push
 navigator.push([.detail(id: "1"), .detail(id: "2")])

 // MARK: - Replace
 navigator.replace(with: [.home, .settings])

 // MARK: - Back
 navigator.back()

 // MARK: - 특정 화면으로 이동
 navigator.backTo(.home)

 // MARK: - 있으면 pop / 없으면 push
 navigator.backOrPush(.settings)

 // MARK: - Modal
 navigator.present(.settings)

 // MARK: - FullScreen Modal
 navigator.presentFullScreen(.settings)

 // MARK: - Modal dismiss
 navigator.dismissModal()

 // MARK: - Tab 이동
 navigator.switchTab(tag: 1)
 */
