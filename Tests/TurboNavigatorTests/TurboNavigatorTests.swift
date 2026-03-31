import UIKit
import XCTest
@testable import TurboNavigator

/**
 
 MARK: - Core Concepts

 Route
 - 화면을 식별하는 타입 (enum)
 - 네비게이션의 "주소" 역할
 - ex) .home, .detail
 
 
 RouteRegistry
 - Route → ViewController 생성 로직을 등록하는 저장소
 - 일종의 "ViewController 공장 목록"
 - 각 Route에 대해 어떤 ViewController를 생성할지 정의
 
 - ex)
   .home → HomeViewController
   .detail → DetailViewController
 
 
 Navigator
 - Route 기반으로 실제 화면 전환(push, present 등)을 수행하는 엔진
 - ViewController를 직접 생성하지 않고,
   RouteRegistry를 통해 생성된 ViewController를 사용
 
 - 역할
   1. Route 전달받음
   2. Registry 통해 ViewController 생성
   3. NavigationController에 반영
 
 
 Build
 - Route → ViewController로 변환하는 과정
 - RouteRegistry 내부에 등록된 builder를 찾아 실행
 
 - 흐름
   route 입력
    → 등록된 builder 중 매칭되는 것 탐색
    → build 클로저 실행
    → ViewController 생성 및 반환
 
 
 AnyRouteIdentifiable
 - ViewController가 어떤 Route로 생성되었는지 식별하기 위한 프로토콜
 - 네비게이션 스택에서 특정 Route를 찾거나 비교할 때 사용
 
 - 활용 예
   - popToRoute
   - 현재 스택 상태 추적
   - 중복 push 방지
 
 */
private enum TestRoute: Hashable {
    case home
    case detail
    case settings
    case missing
}

private enum AssociatedRoute: Hashable {
    case detail(id: String)
}

private final class TestViewController: UIViewController, AnyRouteIdentifiable {
    let route: TestRoute
    let anyRoute: AnyHashable
    
    init(route: TestRoute) {
        self.route = route
        self.anyRoute = AnyHashable(route)
        super.init(nibName: nil, bundle: nil)
    }
    
    /// https://ios-development.tistory.com/615
    /// Compile time에 error
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}

private final class AssociatedTestViewController: UIViewController, AnyRouteIdentifiable {
    let route: AssociatedRoute
    let anyRoute: AnyHashable
    let extractedId: String
    
    init(route: AssociatedRoute, extractedId: String) {
        self.route = route
        self.anyRoute = AnyHashable(extractedId)
        self.extractedId = extractedId
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class PresenterNavigationController: UINavigationController {
    private(set) var presentCallCount = 0
    private(set) var dismissCallCount = 0
    
    override func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        self.presentCallCount += 1
        completion?()
    }
    
    override func dismiss(
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        dismissCallCount += 1
        completion?()
    }
}

final class TurboNavigatorTests: XCTestCase {
    
    // route
    func test_레지스트리가_일치하는_컨트롤러를_생성한다() {
        
        /// given
        /// .home route가 들어오면 TestViewController를 생성하도록 registry 구성
        let registry = RouteRegistry<Void, TestRoute>()
            .registering(TestRoute.home) { context in
                TestViewController(route: context.route)
            }
        
        /// Navigator 생성 ( Route 기반 네비게이션 엔진)
        let navigator = Navigator<Void, TestRoute>(
            dependencies: (),
            registry: registry
        )
        
        /// when
        /// .home route를 build하여 실제 ViewController 생성
        let built: (any RouteViewController)? = registry.build(
            route: TestRoute.home,
            navigator: navigator,
            dependencies: ()
        )
        
        /// then
        /// ViewController가 정상적으로 생성되는지
        XCTAssertNotNil(built)
        
        /// 생성된 ViewController가 올바른 route 정보를 가지고 있는지
        XCTAssertEqual(built?.anyRoute, AnyHashable(TestRoute.home))
    }
    
    func test_extracting_builder는_연관값_route를_생성한다() {
        
        /// given
        let registry = RouteRegistry<Void, AssociatedRoute>()
            .registering { route in
                guard case let AssociatedRoute.detail(id) = route else { return nil }
                return id
            } build: { context, id in
                AssociatedTestViewController(route: context.route, extractedId: id)
            }
        
        let navigator = Navigator<Void, AssociatedRoute>(
            dependencies: (),
            registry: registry
        )
        
        let built = registry.build(
            route: AssociatedRoute.detail(id: "42"),
            navigator: navigator,
            dependencies: ()
        )
        
        /// then
        XCTAssertNotNil(built)
        XCTAssertEqual((built as? AssociatedTestViewController)?.extractedId, "42")
    }
    
    // push
    func test_push를_호출하면_root_stack에_컨트롤러가_추가된다() {
        
        /// given
        let registry = RouteRegistry<Void, TestRoute>()
            .registering(TestRoute.home) { context in
                TestViewController(route: context.route)
            }
            .registering(TestRoute.detail) { context in
                TestViewController(route: context.route)
            }
        
        let navigator = Navigator<Void, TestRoute>(
            dependencies: (),
            registry: registry
        )
        
        let rootController = UINavigationController()
        rootController.setViewControllers(
            navigator.launch([TestRoute.home]),
            animated: false
        )
        navigator.rootController = rootController
        navigator.push(TestRoute.detail, animated: false)
        
        /// then
        XCTAssertEqual(rootController.viewControllers.count, 2)
        XCTAssertEqual((rootController.viewControllers.last as? TestViewController)?.route, TestRoute.detail)
    }
    
    func test_등록되지_않은_route를_push하면_stack이_변하지_않는다() {
        
        /// given
        let registry = RouteRegistry<Void, TestRoute>()
            .registering(TestRoute.home) { context in
                TestViewController(route: context.route)
            }
        
        let navigator = Navigator<Void, TestRoute>(
            dependencies: (),
            registry: registry
        )
        
        let rootController = UINavigationController()
        rootController.setViewControllers(navigator.launch([TestRoute.home]), animated: false)
        navigator.rootController = rootController
        navigator.push(TestRoute.missing, animated: false)
        
        /// then
        XCTAssertEqual(rootController.viewControllers.count, 1)
        XCTAssertEqual((rootController.viewControllers.first as? TestViewController)?.route, TestRoute.home)
    }
    
    // present
    func test_present를_호출하면_모달_컨트롤러가_생성된다() {
        
        /// given
        let registry = RouteRegistry<Void, TestRoute>()
            .registering(TestRoute.settings) { context in
                TestViewController(route: context.route)
            }
        
        let navigator = Navigator<Void, TestRoute>(
            dependencies: (),
            registry: registry,
            modalCoordinator: ModalCoordinator(makeNavigationController: { PresenterNavigationController() }))
        
        let rootController = PresenterNavigationController()
        navigator.rootController = rootController
        navigator.present(TestRoute.settings, animated: false)
 
        /// then
        XCTAssertTrue(navigator.isModalActive)
        XCTAssertNotNil(navigator.modalController)
        XCTAssertEqual(rootController.presentCallCount, 1)
        XCTAssertEqual(
            (navigator.modalController?.viewControllers.first as? TestViewController)?.route,
            TestRoute.settings
        )
    }
    
    func test_present는_기존_모달이_있으면_교체한다() {
        
        /// given
        let registry = RouteRegistry<Void, TestRoute>()
            .registering(TestRoute.home) { context in
                TestViewController(route: context.route)
            }
            .registering(TestRoute.settings) { context in
                TestViewController(route: context.route)
            }
        
        let navigator = Navigator<Void, TestRoute>(
            dependencies: (),
            registry: registry,
            modalCoordinator: ModalCoordinator(makeNavigationController: { PresenterNavigationController() })
        )
        
        let rootController = PresenterNavigationController()
        navigator.rootController = rootController
        
        navigator.present(TestRoute.home, animated: false)
        let firstModal = navigator.modalController as? PresenterNavigationController
        
        navigator.present(TestRoute.settings, animated: false)
        let secondModal = navigator.modalController as? PresenterNavigationController
        
        /// then
        XCTAssertNotNil(firstModal)
        XCTAssertNotNil(secondModal)
        XCTAssertFalse(firstModal === secondModal)
        XCTAssertEqual(firstModal?.dismissCallCount, 1)
        XCTAssertEqual(rootController.presentCallCount, 2)
    }
    
    func test_presentFullScreen은_fullScreen_스타일을_적용한다() {
        
        /// given
        let registry = RouteRegistry<Void, TestRoute>()
            .registering(TestRoute.settings) { context in
                TestViewController(route: context.route)
            }
        
        let navigator = Navigator<Void, TestRoute>(
            dependencies: (),
            registry: registry,
            modalCoordinator: ModalCoordinator(makeNavigationController: { PresenterNavigationController() })
        )
        
        let rootController = PresenterNavigationController()
        navigator.rootController = rootController
        navigator.presentFullScreen(TestRoute.settings, animated: false)
        
        /// then
        XCTAssertEqual(navigator.modalController?.modalPresentationStyle, .fullScreen)
    }
    
    // dismiss
    func test_modal의_root에서_back을_호출하면_diss된다() {
        
        /// given
        let registry = RouteRegistry<Void, TestRoute>()
            .registering(TestRoute.settings) { context in
                TestViewController(route: context.route)
            }
        
        let navigator = Navigator<Void, TestRoute>(
            dependencies: (),
            registry: registry,
            modalCoordinator: ModalCoordinator(makeNavigationController: { PresenterNavigationController() }))
        
        let rootController = PresenterNavigationController()
        navigator.rootController = rootController
        navigator.present(TestRoute.settings, animated: false)
        
        /// then
        let modalController = navigator.modalController as? PresenterNavigationController
        XCTAssertNotNil(modalController)
        
        navigator.back(animated: false)
        XCTAssertEqual(modalController?.dismissCallCount, 1)
    }
    
    // other
    func test_backOrPush는_이미_존재하는_route가_있으면_pop한다() {
        
        /// given
        let registry = RouteRegistry<Void, TestRoute>()
            .registering(TestRoute.home) { context in
                TestViewController(route: context.route)
            }
            .registering(TestRoute.detail) { context in
                TestViewController(route: context.route)
            }
            .registering(TestRoute.settings) { context in
                TestViewController(route: context.route)
            }
        
        let navigator = Navigator<Void, TestRoute>(
            dependencies: (),
            registry: registry
        )
        
        let rootController = UINavigationController()
        rootController
            .setViewControllers(
                navigator.launch([TestRoute.home, TestRoute.detail, TestRoute.settings]),
                animated: false
            )
        navigator.rootController = rootController
        navigator.backOrPush(TestRoute.detail, animated: false)
        
        /// then
        XCTAssertEqual(rootController.viewControllers.count, 2)
        XCTAssertEqual((rootController.viewControllers.last as? TestViewController)?.route, TestRoute.detail)
    }
    
    func test_replace는_현재_stack을_새_route들로_교체한다() {
        
        /// given
        let registry = RouteRegistry<Void, TestRoute>()
            .registering(TestRoute.home) { context in
                TestViewController(route: context.route)
            }
            .registering(TestRoute.detail) { context in
                TestViewController(route: context.route)
            }
            .registering(TestRoute.settings) { context in
                TestViewController(route: context.route)
            }
        
        let navigator = Navigator<Void, TestRoute>(
            dependencies: (),
            registry: registry
        )
        
        let rootController = UINavigationController()
        rootController
            .setViewControllers(
                navigator.launch([TestRoute.home, TestRoute.detail, TestRoute.settings]),
                animated: false
            )
        navigator.rootController = rootController
        navigator.replace(with: [TestRoute.settings], animated: false)
        
        /// then
        XCTAssertEqual(rootController.viewControllers.count, 1)
        XCTAssertEqual((rootController.viewControllers.last as? TestViewController)?.route, TestRoute.settings)
    }
    
    func test_backTo는_마지막으로_일치하는_route까지_이동한다() {
        
        /// given
        let registry = RouteRegistry<Void, TestRoute>()
            .registering(TestRoute.home) { context in
                TestViewController(route: context.route)
            }
            .registering(TestRoute.detail) { context in
                TestViewController(route: context.route)
            }
            .registering(TestRoute.settings) { context in
                TestViewController(route: context.route)
            }
        
        let navigator = Navigator<Void, TestRoute>(
            dependencies: (),
            registry: registry
        )
        
        let rootController = UINavigationController()
        rootController
            .setViewControllers(
                navigator.launch([TestRoute.home, TestRoute.detail, TestRoute.settings, TestRoute.detail, TestRoute.settings]),
                animated: false
            )
        navigator.rootController = rootController
        navigator.backTo(TestRoute.detail, animated: false)
        
        /// then
        XCTAssertEqual(rootController.viewControllers.count, 4)
        XCTAssertEqual((rootController.viewControllers.last as? TestViewController)?.route, TestRoute.detail)
    }
    
    // tab
    
}
