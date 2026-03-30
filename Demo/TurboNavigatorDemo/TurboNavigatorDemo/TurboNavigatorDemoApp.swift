//
//  TurboNavigatorDemoApp.swift
//  TurboNavigatorDemo
//
//  Created by 김동현 on 3/29/26.
//

import SwiftUI
import LinkNavigator

@main
struct TurboNavigatorDemoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var navigator: LinkNavigator {
      appDelegate.navigator
    }
    
    var body: some Scene {
        WindowGroup {
            navigator
              .launch(paths: ["home"], items: [:])
              .onOpenURL { url in
              }
        }
    }
}

import SwiftUI
import LinkNavigator

struct HomeView: View {
    
    let navigator: LinkNavigatorType
    
    var body: some View {
        print("HomeView 호출")
        return VStack {
            
            Text("Home View")
                .font(.title)
            Button(action: {
                // ✅
                navigator.next(paths: ["next"], items: [:], isAnimated: true)
            }) {
                Text("Next View")
            }
            
        }
    }
}
import LinkNavigator
import SwiftUI

struct HomeRouteBuilder: RouteBuilder {
    var matchPath: String { "home" } // ✅ 화면 전환에 필요한 path
    
    var build: (LinkNavigatorType, [String: String], DependencyType) -> MatchingViewController? {
        { navigator, items, dependency in
            return WrappingController(matchPath: matchPath) {
                HomeView(navigator: navigator) // ✅ 화면 전환할 SwiftUI View
            }
        }
    }
}
