//
//  ModalCoordinator.swift.swift
//  TurboNavigator
//
//  Created by 김동현 on 3/30/26.
//

import UIKit

/// Modal 방식의 화면 전환을 담당하는 Coordinator
///
/// - Note:
///   내부적으로 별도의 `UINavigationController`를 생성하여
///   modal stack을 구성한 뒤 presenter 위에 표시합니다.
///
/// - 특징:
///   - NavigationController 생성 로직을 외부에서 주입 가능(테스트 용이성)
///   - Route 배열 기반으로 여러 화면을 stack 형태로 구성
///   - 기존 modal이 있을 경우 안전하게 dismiss후 재표시
///
/// - Generic:
///   - Dependencies: 화면 생성 시 필요한 외부 의존성
///   - Route: Hashable한 라우팅 타입
public struct ModalCoordinator<Dependencies, Route: Hashable> {
    
    
    /// UINavigationController 생성 팩토리
    ///
    /// - Note
    ///   테스트 시 mock Navigation Controller 주입 가능
    public let makeNavigationController: () -> UINavigationController
    
    
    /// 기본 생성자
    /// - Parameter makeNavigationController: 커스텀 UINavigationController 생성 클로저 (기본값: 기본 UINavigationController)
    public init(
        makeNavigationController: @escaping () -> UINavigationController = { UINavigationController() }
    ) {
        self.makeNavigationController = makeNavigationController
    }
    
    
    /// 주어진 Route 배열을 기반으로 modal navigation stack을 생성하고 표시합니다.
    ///
    /// - Parameters:
    ///   - routes: modal stack을 구성할 route 배열
    ///   - presenter: modal을 띄울 UINavigationController
    ///   - existingModalController: 이미 떠 있는 modal (있다면 먼저 dismiss)
    ///   - navigator: ViewController 생성에 사용되는 Navigator
    ///   - animated: 애니메이션 여부
    ///   - presentationStyle: modal 표시 스타일
    ///
    /// - Returns:
    ///   생성 및 표시된 UINavigationController (modal controller)
    ///
    /// - Important:
    ///   presenter가 nil이면 아무 작업도 수행하지 않고 nil 반환
    ///
    /// - Flow:
    ///   1. 기존 modal dismiss
    ///   2. 새로운 UINavigationController 생성
    ///   3. registry를 통해 ViewController 배열 생성
    ///   4. navigation stack 구성
    ///   5. modal present
    public func present(
        routes: [Route],
        from presenter: UINavigationController?,
        existingModalController: UINavigationController?,
        navigator: Navigator<Dependencies, Route>,
        animated: Bool,
        presentationStyle: ModalPresentationStyle
    ) -> UINavigationController? {
        
        guard let presenter else { return nil }
        
        // 기존 modal 제거
        existingModalController?.dismiss(animated: animated)
        
        // 새로운 modal navigation 생성
        let modalController = makeNavigationController()
        modalController.modalPresentationStyle = presentationStyle.uiKitStyle
        
        // Route -> ViewController 변환
        let viewControllers = navigator.registry.build(
            routes: routes,
            navigator: navigator,
            dependencies: navigator.dependencies
        )
        
        // navigation stack 구성
        modalController.setViewControllers(viewControllers, animated: false)
        modalController.applyNavigationBarVisibility(for: viewControllers.first)
        
        // modal 표시
        presenter.present(modalController, animated: animated)
        return modalController
    }
    
    
    /// 현재 표시된 modal navigation controller를 dismiss합니다.
    ///
    /// - Parameters:
    ///   - modalController: dismiss할 modal navigation controller
    ///   - animated: 애니메이션 여부
    ///   - completion: dismiss 완료 후 실행할 클로저
    public func dismiss(
        modalController: UINavigationController?,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        modalController?.dismiss(animated: animated, completion: completion)
    }
}


/**
 MARK: - Example

 enum AppRoute: Hashable {
   case login
   case signup
 }

 let navigator = Navigator<AppDependencies, AppRoute>(...)

 let modalCoordinator = ModalCoordinator<AppDependencies, AppRoute>()

 // 현재 네비게이션 컨트롤러
 let presenter = navigationController

 // 기존 modal (optional)
 var currentModal: UINavigationController?

 // MARK: - Present
 currentModal = modalCoordinator.present(
   routes: [.login, .signup],
   from: presenter,
   existingModalController: currentModal,
   navigator: navigator,
   animated: true,
   presentationStyle: .fullScreen
 )

 // MARK: - Dismiss
 modalCoordinator.dismiss(
   modalController: currentModal,
   animated: true
 )
 */
