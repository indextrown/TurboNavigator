//
//  LinkNavigatorView.swift
//  TurboNavigatorDemo
//
//  Created by 김동현 on 3/30/26.
//

import Foundation
import LinkNavigator

// MARK: - AppDependency.swift
/// 외부 의존성을 관리하는 타입입니다.
///
/// DependencyType 프로토콜을 채택해야 합니다.
struct AppDependency: DependencyType { }

// MARK: - AppRouterGroup.swift
/// LinkNavigator 를 통해 이동하고 싶은 화면들을 관리하는 타입
struct AppRouterGroup {
    var routers: [RouteBuilder] {
        [
            HomeRouteBuilder(),
            NextRouteBuilder()
        ]
    }
}

// MARK: - AppDelegate.swift
import SwiftUI
import LinkNavigator

final class AppDelegate: NSObject {
  var navigator: LinkNavigator {
    LinkNavigator(dependency: AppDependency(), builders: AppRouterGroup().routers)
  }
}

extension AppDelegate: UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    true
  }
}

struct NextView: View {
    
    let navigator: LinkNavigatorType
    
    init(navigator: LinkNavigatorType) {
        self.navigator = navigator
    }
    
    var body: some View {
        print("NextView 호출")
        return VStack {
            Text("Next View")
                .font(.title)
        }
    }
}

import LinkNavigator
import SwiftUI

struct NextRouteBuilder: RouteBuilder {
    
  var matchPath: String { "next" }

  var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
    { navigator, items, dependency in
        return WrappingController(matchPath: matchPath) {
            NextView(navigator: navigator)
      }
    }
  }
}
