# TurboNavigator Todo

## 화면별 NavigationBar / TabBar 설정 개선

현재 `WrappingController`는 화면별로 `title`, `isNavigationBarHidden`,
`isTabBarHiddenWhenPushed` 정도만 설정할 수 있다.
나중에 SwiftUI 사용자가 UIKit appearance를 직접 만지는 일을 줄이기 위해
아래 API들을 검토한다.

### 1. NavigationBarConfiguration

화면별 navigation bar 설정 모델.

```swift
WrappingController(
  route: context.route,
  navigationBar: .init(
    title: "Detail",
    isHidden: false,
    prefersLargeTitle: false
  )
) {
  DetailView(navigator: context.navigator)
}
```

후보 속성:

```swift
public struct NavigationBarConfiguration {
  public var title: String?
  public var isHidden: Bool?
  public var prefersLargeTitle: Bool?
  public var appearance: NavigationBarAppearance?
}
```

### 2. TabBarConfiguration

화면별 tab bar 설정 모델.

```swift
WrappingController(
  route: context.route,
  tabBar: .init(
    visibility: .hiddenWhenPushed
  )
) {
  DetailView(navigator: context.navigator)
}
```

후보 속성:

```swift
public struct TabBarConfiguration {
  public var visibility: TabBarVisibility
  public var appearance: TabBarAppearance?
}
```

### 3. TabBarVisibility

tab bar 표시 정책.

```swift
public enum TabBarVisibility {
  case inherit
  case visible
  case hidden
  case hiddenWhenPushed
}
```

사용 예시:

```swift
WrappingController(
  route: context.route,
  tabBar: .init(visibility: .hiddenWhenPushed)
) {
  DetailView()
}
```

### 4. NavigationBarAppearance

navigation bar 색상, 배경, 타이틀 스타일 설정.

```swift
WrappingController(
  route: context.route,
  navigationBar: .init(
    title: "Profile",
    appearance: .init(
      backgroundColor: .black,
      titleColor: .white,
      largeTitleColor: .white,
      tintColor: .white,
      shadowColor: .clear,
      isTranslucent: false
    )
  )
) {
  ProfileView()
}
```

후보 속성:

```swift
public struct NavigationBarAppearance {
  public var backgroundColor: UIColor?
  public var titleColor: UIColor?
  public var largeTitleColor: UIColor?
  public var tintColor: UIColor?
  public var shadowColor: UIColor?
  public var isTranslucent: Bool
}
```

### 5. TabBarAppearance

tab bar 색상, 배경, 선택 색상 설정.

```swift
WrappingController(
  route: context.route,
  tabBar: .init(
    visibility: .visible,
    appearance: .init(
      backgroundColor: .systemBackground,
      selectedColor: .systemBlue,
      unselectedColor: .secondaryLabel,
      shadowColor: .separator,
      isTranslucent: false
    )
  )
) {
  HomeView()
}
```

후보 속성:

```swift
public struct TabBarAppearance {
  public var backgroundColor: UIColor?
  public var selectedColor: UIColor?
  public var unselectedColor: UIColor?
  public var shadowColor: UIColor?
  public var isTranslucent: Bool
}
```

### 6. Appearance preset

자주 쓰는 스타일을 짧게 쓰기 위한 preset.

```swift
WrappingController(
  route: context.route,
  navigationBar: .init(
    title: "Home",
    prefersLargeTitle: true,
    appearance: .transparent()
  ),
  tabBar: .init(
    visibility: .visible,
    appearance: .opaque()
  )
) {
  HomeView()
}
```

후보 preset:

```swift
NavigationBarAppearance.default
NavigationBarAppearance.opaque()
NavigationBarAppearance.transparent()
NavigationBarAppearance.hiddenShadow()

TabBarAppearance.default
TabBarAppearance.opaque()
TabBarAppearance.transparent()
```

### 7. WrappingController 새 init

기존 init은 유지하고 새 init을 추가한다.

```swift
public init(
  route: Route,
  navigationBar: NavigationBarConfiguration = .init(),
  tabBar: TabBarConfiguration = .init(),
  @ViewBuilder content: () -> Content
)
```

사용 예시:

```swift
WrappingController(
  route: context.route,
  navigationBar: .init(title: "Detail"),
  tabBar: .init(visibility: .hiddenWhenPushed)
) {
  DetailView()
}
```

기존 방식은 유지한다.

```swift
WrappingController(
  route: context.route,
  title: "Detail",
  isNavigationBarHidden: false,
  isTabBarHiddenWhenPushed: true
) {
  DetailView()
}
```

### 8. Container 기본값 설정

전체 navigation stack / tab container에 기본 appearance를 지정한다.

```swift
NavigationContainer(
  navigator: navigator,
  initialRoutes: [.home],
  navigationBar: .init(
    prefersLargeTitles: true,
    appearance: .opaque()
  )
)
```

```swift
TabNavigationContainer(
  navigator: navigator,
  items: items,
  tabBar: .init(
    isHidden: false,
    appearance: .opaque()
  )
)
```

### 9. 탭별 NavigationBar appearance

각 탭의 root navigation controller마다 스타일을 지정한다.

```swift
TabNavigationItem(
  tag: 0,
  route: .home,
  tabBarItem: UITabBarItem(title: "Home", image: nil, tag: 0),
  prefersLargeTitles: true,
  navigationBarAppearance: .transparent()
)

TabNavigationItem(
  tag: 1,
  route: .settings,
  tabBarItem: UITabBarItem(title: "Settings", image: nil, tag: 1),
  prefersLargeTitles: false,
  navigationBarAppearance: .opaque()
)
```

### 10. UIKit escape hatch

라이브러리 설정으로 부족할 때 UIKit 객체에 직접 접근할 수 있게 한다.

```swift
WrappingController(
  route: context.route,
  navigationBar: .init(title: "Checkout"),
  tabBar: .init(visibility: .hiddenWhenPushed),
  configureViewController: { controller in
    controller.navigationItem.backButtonDisplayMode = .minimal
    controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }
) {
  CheckoutView()
}
```

컨테이너 단위:

```swift
NavigationContainer(
  navigator: navigator,
  initialRoutes: [.home],
  configureNavigationController: { nav in
    nav.navigationBar.tintColor = .systemPurple
  }
)
```

```swift
TabNavigationContainer(
  navigator: navigator,
  items: items,
  configureTabBarController: { tab in
    tab.tabBar.backgroundColor = .systemBackground
  }
)
```

### 추천 구현 순서

1. `NavigationBarConfiguration`
2. `TabBarConfiguration`
3. `TabBarVisibility`
4. `NavigationBarAppearance`
5. `TabBarAppearance`
6. preset
7. `WrappingController` 새 init
8. container 기본값
9. 탭별 navigation appearance
10. UIKit escape hatch

## Route extractor 매크로

associated value가 있는 enum route를 `RouteRegistry.registering(extracting:)`에
짧게 등록하기 위한 매크로를 나중에 검토한다.

현재는 아래처럼 case 추출 로직을 직접 작성해야 한다.

```swift
.registering(
  extracting: { route in
    guard case let .detail(id) = route else { return nil }
    return id
  },
  build: { context, id in
    DetailView(userID: id)
  }
)
```

목표 사용 예시:

```swift
@RouteCases
enum AppRoute: Hashable {
  case home
  case detail(id: String)
  case profile(userID: String, tab: Int)
  case settings
}
```

매크로가 생성할 코드 후보:

```swift
extension AppRoute {
  enum Cases {
    static func detail(_ route: AppRoute) -> String? {
      guard case let .detail(id) = route else { return nil }
      return id
    }

    static func profile(_ route: AppRoute) -> (userID: String, tab: Int)? {
      guard case let .profile(userID, tab) = route else { return nil }
      return (userID, tab)
    }
  }
}
```

사용 예시:

```swift
let registry = RouteRegistry<AppDependencies, AppRoute>()
  .registering(.home) { context in
    WrappingController(route: context.route, title: "Home") {
      HomeView(navigator: context.navigator)
    }
  }
  .registering(extracting: AppRoute.Cases.detail) { context, id in
    WrappingController(route: context.route, title: "Detail") {
      DetailView(
        userID: id,
        repository: context.dependencies.userRepository,
        navigator: context.navigator
      )
    }
  }
  .registering(extracting: AppRoute.Cases.profile) { context, profile in
    WrappingController(route: context.route, title: "Profile") {
      ProfileView(
        userID: profile.userID,
        initialTab: profile.tab,
        navigator: context.navigator
      )
    }
  }
  .registering(.settings) { context in
    WrappingController(route: context.route, title: "Settings") {
      SettingsView(navigator: context.navigator)
    }
  }
```

라이브러리에 짧은 alias API를 추가하면 아래처럼 줄일 수 있다.

```swift
public func registering<Value>(
  _ extract: @escaping (Route) -> Value?,
  build: @escaping (RouteContext<Dependencies, Route>, Value) -> RouteViewController?
) -> Self {
  registering(extracting: extract, build: build)
}
```

최종 사용 후보:

```swift
let registry = RouteRegistry<AppDependencies, AppRoute>()
  .registering(.home) { context in
    HomeView(navigator: context.navigator)
  }
  .registering(AppRoute.Cases.detail) { context, id in
    DetailView(userID: id)
  }
  .registering(AppRoute.Cases.profile) { context, profile in
    ProfileView(
      userID: profile.userID,
      initialTab: profile.tab
    )
  }
  .registering(.settings) { context in
    SettingsView(navigator: context.navigator)
  }
```

검토 포인트:

- associated value가 없는 case는 기존 `.registering(.settings)`로 충분하므로 생성하지 않아도 된다.
- associated value가 1개면 값 타입을 그대로 반환한다.
- associated value가 2개 이상이면 labeled tuple을 반환한다.
- `TurboNavigatorMacros` target과 SwiftSyntax 의존성이 필요할 수 있다.
- iOS 13 런타임 지원과 별개로 빌드 도구 요구 버전이 올라갈 수 있다.
- 지금 당장 넣기에는 무겁고, 사용성 개선용 장기 후보로 둔다.

---

## 프로젝트 개선 체크리스트

이 체크리스트는 2026-07-25 기준 프로젝트 분석에서 확인한 개선 후보를 추적한다.

### 현재 기준선

- [x] iOS generic destination package build 성공
- [x] Mac Catalyst에서 테스트 21개 성공
- [x] 라이브러리 라인 커버리지 확인: 51.27% (444/866)
- [ ] Swift 6 strict-concurrency build 성공
- [ ] 대표 SwiftUI demo build 성공
- [ ] 대표 UIKit demo build 성공

### P0: 동작 안정성

#### 1. Tab container 수명주기 정리

관련 파일:

- `Sources/TurboNavigator/Core/9. TabCoordinator.swift`
- `Sources/TurboNavigator/Core/3. Navigator.swift`
- `Sources/TurboNavigator/Adapter/12. TabNavigationContainer.swift`

체크리스트:

- [ ] `TabCoordinator`에 controller와 캐시를 정리하는 `detach` 동작을 정의한다.
- [ ] `TabNavigationContainer.dismantleUIViewController`에서 coordinator를 분리한다.
- [ ] tab container가 사라진 뒤 `activeController`가 숨겨진 tab stack을 반환하지 않게 한다.
- [ ] tab navigation controller와 화면이 정상적으로 해제되는지 테스트한다.
- [ ] tab container에서 root container로 전환한 뒤 push 대상이 올바른지 테스트한다.
- [ ] root, tab, modal의 active stack 우선순위가 유지되는지 확인한다.

완료 조건:

- [ ] 해제된 tab stack으로 navigation 명령이 전달되지 않는다.
- [ ] tab container 제거 후 불필요한 controller 순환 참조가 남지 않는다.

#### 2. Modal 교체와 dismiss 상태 동기화

관련 파일:

- `Sources/TurboNavigator/Core/8. ModalCoordinator.swift`
- `Sources/TurboNavigator/Core/3. Navigator.swift`

체크리스트:

- [ ] 기존 modal dismiss 완료 후 새 modal 상태를 확정하도록 흐름을 변경한다.
- [ ] 새 modal이 실제로 presentation된 뒤 observer delegate를 연결한다.
- [ ] interactive dismiss 후 `modalController`가 정리되는지 테스트한다.
- [ ] modal 교체 중 연속된 present, dismiss 요청의 정책을 정의한다.
- [ ] dismiss 진행 중 push가 stale modal stack으로 전달되지 않게 한다.
- [ ] modal 교체 실패 시 기존 navigation 상태가 어떻게 유지될지 정의한다.

완료 조건:

- [ ] modal 교체 후 swipe dismiss를 해도 stale controller가 남지 않는다.
- [ ] `isModalActive`, `activeController`, debug snapshot이 실제 UI 상태와 일치한다.

#### 3. Swift 6 MainActor 격리

관련 파일:

- `Sources/TurboNavigator/Core/3. Navigator.swift`
- `Sources/TurboNavigator/Core/8. ModalCoordinator.swift`
- `Sources/TurboNavigator/Core/9. TabCoordinator.swift`
- `Sources/TurboNavigator/Adapter/10. WrappingController.swift`
- `Sources/TurboNavigator/Adapter/11. NavigationContainer.swift`
- `Sources/TurboNavigator/Adapter/12. TabNavigationContainer.swift`

체크리스트:

- [ ] UIKit을 다루는 Navigator와 coordinator의 actor 경계를 정의한다.
- [ ] `AnyRouteIdentifiable`과 `WrappingController`의 conformance 격리를 정리한다.
- [ ] navigation-controller factory closure의 actor 격리를 명시한다.
- [ ] public API 호출부에 미치는 source compatibility 영향을 확인한다.
- [ ] 테스트 코드도 동일한 actor 규칙을 따르게 한다.
- [ ] Swift 5 모드와 Swift 6 모드에서 모두 빌드한다.

완료 조건:

- [ ] 아래 strict-concurrency build가 성공한다.

```bash
xcodebuild \
  -scheme TurboNavigator \
  -destination "generic/platform=iOS" \
  build \
  SWIFT_VERSION=6 \
  SWIFT_STRICT_CONCURRENCY=complete
```

### P1: API 신뢰성과 테스트

#### 4. 다중 route build의 원자성 및 실패 진단

관련 파일:

- `Sources/TurboNavigator/Registry/5. RouteBuilder.swift`
- `Sources/TurboNavigator/Registry/6. RouteRegistry.swift`
- `Sources/TurboNavigator/Core/3. Navigator.swift`
- `Sources/TurboNavigator/DeepLink/16. Navigator+DeepLink.swift`

체크리스트:

- [ ] 등록되지 않은 route가 포함된 다중 build의 정책을 정의한다.
- [ ] 부분 stack 생성 허용 여부를 public contract에 명시한다.
- [ ] strict build 또는 all-or-nothing API 제공을 검토한다.
- [ ] navigation 명령의 성공, 실패 결과를 호출자가 확인할 방법을 제공한다.
- [ ] 미등록 route와 중복 builder를 진단할 logger 또는 hook을 검토한다.
- [ ] 빈 route 배열에 대한 push, replace, present 동작을 명시한다.
- [ ] deep link route 일부가 build되지 않을 때의 동작을 테스트한다.

완료 조건:

- [ ] route build 실패가 조용한 부분 navigation으로 이어지지 않는다.
- [ ] 기존 API 호환성을 유지하거나 breaking change를 명확히 문서화한다.

#### 5. Tab 직접 재선택 및 iOS 18 전환 정책 정리

관련 파일:

- `Sources/TurboNavigator/Core/9. TabCoordinator.swift`
- `Sources/TurboNavigator/Adapter/12. TabNavigationContainer.swift`
- `README.md`
- `README.en.md`

체크리스트:

- [ ] tab bar를 직접 다시 눌렀을 때 root로 돌아갈지 정책을 확정한다.
- [ ] `navigator.switchTab`과 직접 탭 선택의 동작을 일치시킨다.
- [ ] iOS 18 animation disable 구현이 UIKit view hierarchy를 변경하지 않는지 검증한다.
- [ ] programmatic switch와 사용자 탭 전환을 각각 테스트한다.
- [ ] 동일 tag가 여러 번 등록될 때 validation을 추가한다.
- [ ] 선택된 tag와 `selectedViewController`가 항상 일치하는지 테스트한다.
- [ ] README의 탭 UX 설명을 실제 동작과 일치시킨다.

완료 조건:

- [ ] 직접 탭과 programmatic 탭 전환의 동작 차이가 문서화되거나 제거된다.
- [ ] iOS 17 이하와 iOS 18 이상의 탭 전환 회귀가 없다.

#### 6. Adapter, Tab, DeepLink 테스트 확장

관련 파일:

- `Tests/TurboNavigatorTests/TurboNavigatorTests.swift`
- `Sources/TurboNavigator/Adapter`
- `Sources/TurboNavigator/DeepLink`

체크리스트:

- [ ] 단일 테스트 파일을 registry, stack, modal, tab, adapter, deep link 단위로 분리한다.
- [ ] `NavigationContainer` 생성 및 update lifecycle을 테스트한다.
- [ ] `TabNavigationContainer` 생성, update, rebuild, dismantle lifecycle을 테스트한다.
- [ ] `WrappingController`의 navigation bar와 tab bar 설정을 테스트한다.
- [ ] deep link의 push, replace, present action을 테스트한다.
- [ ] parser가 nil을 반환할 때 navigation이 발생하지 않는지 테스트한다.
- [ ] interactive modal dismiss 경로를 테스트한다.
- [ ] tab 재선택과 tab stack 독립성을 테스트한다.
- [ ] 테스트 중 실제 window hierarchy 경고가 발생하지 않도록 mock 경계를 정리한다.
- [ ] 주요 공개 navigation 경로의 커버리지 사각지대를 제거한다.

완료 조건:

- [ ] `NavigationContainer`, `TabNavigationContainer`, deep link 실행 코드가 테스트된다.
- [ ] 기존 21개 테스트의 동작 보장을 유지한다.

#### 7. 공개 mutable 상태 캡슐화

관련 파일:

- `Sources/TurboNavigator/Core/3. Navigator.swift`
- `Sources/TurboNavigator/Core/8. ModalCoordinator.swift`
- `Sources/TurboNavigator/Core/9. TabCoordinator.swift`

체크리스트:

- [ ] 외부에서 직접 변경할 필요가 있는 controller 상태를 구분한다.
- [ ] `modalController`를 `private(set)` 또는 내부 상태로 전환할지 검토한다.
- [ ] coordinator 공개 범위를 축소하고 필요한 설정 API만 노출한다.
- [ ] UIKit-only 사용자가 root controller를 연결할 공식 API를 정의한다.
- [ ] 기존 사용자를 위한 deprecation 경로를 설계한다.
- [ ] debug API는 내부 mutable 객체 없이 필요한 상태를 제공하게 한다.

완료 조건:

- [ ] 외부 코드가 Navigator의 active stack 불변식을 임의로 깨뜨리기 어렵다.
- [ ] UIKit과 SwiftUI 사용 사례가 모두 공식 API로 지원된다.

### P2: 패키지와 운영 품질

#### 8. Package 및 Demo 구조 정리

관련 파일:

- `Package.swift`
- `Sources/TurboSwiftUI`
- `Demo`
- `.codex/context/turbonavigator-architecture.md`

체크리스트:

- [ ] `TurboSwiftUI`를 별도 product로 제공할지 제거할지 결정한다.
- [ ] 유지한다면 `Package.swift` target과 테스트를 추가한다.
- [ ] 제거한다면 architecture 문서의 optional target 설명을 수정한다.
- [ ] 불완전한 `Demo/SwiftUIPlainTabDemo`를 복원하거나 제거한다.
- [ ] `Demo/Lab`과 공식 demo의 경계를 문서화한다.
- [ ] 유지할 대표 SwiftUI demo와 UIKit demo를 선정한다.
- [ ] demo-only 가정이 package 코드로 유입되지 않았는지 확인한다.

완료 조건:

- [ ] 저장소의 모든 `Sources` 디렉터리가 package target 또는 명시적인 보관 대상으로 설명된다.
- [ ] 공식 demo는 새 clone 환경에서 빌드 가능하다.

#### 9. CI 및 Release 안전장치 강화

관련 파일:

- `.github/workflows/build-and-test.yml`
- `Makefile`
- `scripts/release.sh`

체크리스트:

- [ ] CI에 대표 SwiftUI demo build를 추가한다.
- [ ] CI에 대표 UIKit demo build를 추가한다.
- [ ] Swift 6 strict-concurrency 검사 job을 추가한다.
- [ ] 지원하는 최소 또는 기준 Xcode 버전 검증 정책을 정한다.
- [ ] `Makefile`의 `Scripts`와 실제 `scripts` 경로 대소문자를 통일한다.
- [ ] release script에 `set -euo pipefail`을 적용한다.
- [ ] release 전 current branch와 clean working tree를 검증한다.
- [ ] release 전 package build와 test를 실행한다.
- [ ] version 형식과 기존 tag 중복을 검증한다.
- [ ] push와 GitHub Release 생성 실패 시 중간 상태 처리 방법을 정한다.

완료 조건:

- [ ] 잘못된 branch, dirty working tree, 실패한 테스트 상태에서 release할 수 없다.
- [ ] package와 대표 demo 회귀가 PR 단계에서 탐지된다.

#### 10. 배포 문서 및 오픈소스 메타데이터

관련 파일:

- `README.md`
- `README.en.md`
- `LICENSE`
- `CHANGELOG.md`
- `CONTRIBUTING.md`

체크리스트:

- [ ] README 설치 예시를 최신 안정 tag와 일치시킨다.
- [ ] 프로젝트 라이선스를 결정하고 `LICENSE`를 추가한다.
- [ ] 버전별 주요 변경을 기록하는 `CHANGELOG.md`를 추가한다.
- [ ] issue, branch, commit, PR 규칙을 `CONTRIBUTING.md`로 공개한다.
- [ ] README 한국어와 영어 버전의 기능 설명을 동기화한다.
- [ ] 지원 OS, Swift, Xcode 버전을 명시한다.
- [ ] public API에 대한 DocC 도입 범위를 검토한다.
- [ ] release 절차와 semantic versioning 기준을 문서화한다.

완료 조건:

- [ ] 외부 사용자가 설치, 라이선스, 기여, 변경 이력을 저장소 문서만으로 확인할 수 있다.
- [ ] README와 실제 package, 최신 release 사이에 버전 불일치가 없다.

### 공통 작업 흐름

각 개선 항목은 독립된 issue와 branch로 처리한다.

- [ ] 기존 open issue에서 중복 여부를 확인한다.
- [ ] 관련 issue가 없으면 하나의 개선 항목만 담은 issue를 생성한다.
- [ ] `codex/<type>-<issue-number>-<short-slug>` 형식으로 branch를 생성한다.
- [ ] public API와 iOS 13 호환성 영향을 확인한다.
- [ ] 관련 package test와 demo build를 실행한다.
- [ ] public API 또는 사용법이 바뀌면 `README.md`와 `README.en.md`를 함께 수정한다.
- [ ] Conventional Commits 형식으로 목적별 commit을 만든다.
- [ ] `[#<issue-number>] <issue-title>` 형식으로 PR을 생성한다.
- [ ] PR 생성 후 merge하지 않고 사용자 승인을 기다린다.

### 기본 검증 명령

```bash
xcodebuild \
  -scheme TurboNavigator \
  -destination "generic/platform=iOS" \
  build
```

```bash
xcodebuild \
  test \
  -scheme TurboNavigator \
  -destination "platform=macOS,variant=Mac Catalyst"
```
