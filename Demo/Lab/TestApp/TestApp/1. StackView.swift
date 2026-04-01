//
//  StackView.swift
//  TestApp
//
//  Created by 김동현 on 4/1/26.
//
// https://green1229.tistory.com/257
// https://velog.io/@snack/SwiftUI-NavigationStack

import SwiftUI

enum Route: Hashable {
    case detailA
    case detailB
    case detailC
}

struct DetailAView: View {
    @Binding var stack: NavigationPath
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Detail A View")
            
            Button("Go to Detail B") {
                stack.append(Route.detailB)
            }
        }
    }
}

struct DetailBView: View {
    @Binding var stack: NavigationPath
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Detail B View")
            
            Button("Go to Detail C") {
                stack.append(Route.detailC)
            }
        }
    }
}

struct DetailCView: View {
    @Binding var stack: NavigationPath
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Detail C View")
            
            Button("Go to Root") {
                stack = NavigationPath()
            }
        }
    }
}

struct StackView: View {
    @State var stack = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $stack) {
            
            VStack(spacing: 20) {
                Text("Root View")
                
                Button("Go to Detail A") {
                    stack.append(Route.detailA)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .detailA:
                    DetailAView(stack: $stack)
                case .detailB:
                    DetailBView(stack: $stack)
                case .detailC:
                    DetailCView(stack: $stack)
                }
            }
        }
    }
}

#Preview {
    StackView()
}
