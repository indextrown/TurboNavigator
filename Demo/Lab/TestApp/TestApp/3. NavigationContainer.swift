//
//  NavigationContainer.swift
//  TestApp
//
//  Created by 김동현 on 4/1/26.
//

import Foundation

enum AppRoute: Hashable, Identifiable {
    case home
    case detail(String)
    case login
    case onboarding
    
    var id: Self { self }
}

import SwiftUI

@Observable
final class Navigator {
    var path: [AppRoute] = []
    
    var sheet: AppRoute?
    var fullScreen: AppRoute?
    
    // MARK: - Actions
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func present(_ route: AppRoute) {
        sheet = route
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    func fullScreen(_ route: AppRoute) {
        fullScreen = route
    }
    
    func dismissFullScreen() {
        fullScreen = nil
    }
}

struct NavigationContainer<Root: View>: View {
    
    @State private var navigator = Navigator()
    let root: Root
    
    init(@ViewBuilder root: () -> Root) {
        self.root = root()
    }
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            root
                .navigationDestination(for: AppRoute.self) { route in
                    build(route)
                }
        }
        .sheet(item: $navigator.sheet) { route in
            build(route)
        }
        .fullScreenCover(item: $navigator.fullScreen) { route in
            build(route)
        }
        .environment(navigator)
    }
    
    @ViewBuilder
    private func build(_ route: AppRoute) -> some View {
        switch route {
        case .home:
            HomeView()
        case .detail(let text):
            DetailView(text: text)
        case .login:
            LoginView()
        case .onboarding:
            OnboardingView()
        }
    }
}


struct HomeView: View {
    
    @Environment(Navigator.self) private var navigator
    
    var body: some View {
        print("HomeView")
        return VStack(spacing: 20) {
            
            Button("Push Detail") {
                navigator.push(.detail("Hello"))
            }
            
            Button("Present Login") {
                navigator.present(.login)
            }
            
            Button("FullScreen Onboarding") {
                navigator.fullScreen(.onboarding)
            }
        }
    }
}

struct DetailView: View {
    
    @Environment(Navigator.self) private var navigator
    let text: String
    
    var body: some View {
        print("DetailView")
        return VStack(spacing: 20) {
            Text("Detail View")
                .font(.largeTitle)
            
            Text("받은 값: \(text)")
            
            Button("Push Another Detail") {
                navigator.push(.detail("Next"))
            }
            
            Button("Pop") {
                navigator.pop()
            }
        }
        .padding()
        .navigationTitle("Detail")
    }
}

struct LoginView: View {
    
    @Environment(Navigator.self) private var navigator
    
    var body: some View {
        print("LoginView")
        return VStack(spacing: 20) {
            Text("Login View")
                .font(.largeTitle)
            
            Button("로그인 성공") {
                navigator.dismissSheet()
                navigator.push(.home)
            }
            
            Button("닫기") {
                navigator.dismissSheet()
            }
        }
        .padding()
    }
}

struct OnboardingView: View {
    
    @Environment(Navigator.self) private var navigator
    
    var body: some View {
        print("OnboardingView")
        return VStack(spacing: 20) {
            Text("Onboarding")
                .font(.largeTitle)
            
            Button("온보딩 완료") {
                navigator.dismissFullScreen()
                navigator.push(.home)
            }
        }
        .padding()
    }
}
