//
//  StackEnumView.swift
//  TestApp
//
//  Created by 김동현 on 4/1/26.
//

import SwiftUI


struct DetailEnumAView: View {
    @Binding var stack: [Route]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Detail A View")
            
            Button("Go to Detail B") {
                stack.append(Route.detailB)
            }
        }
    }
}

struct DetailEnumBView: View {
    @Binding var stack: [Route]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Detail B View")
            
            Button("Go to Detail C") {
                stack.append(Route.detailC)
            }
        }
    }
}

struct DetailEnumCView: View {
    @Binding var stack: [Route]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Detail C View")
            
            Button("Go to A") {
                if let index = stack.firstIndex(of: .detailA) {
                    stack.removeSubrange((index + 1)..<stack.count)
                }
            }
        }
    }
}

struct StackEnumView: View {
    @State var stack: [Route] = []
    
    var body: some View {
        // path
        // [Route]  ⇄  NavigationPath로 자동으로 변환해서 사용함
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
                    DetailEnumAView(stack: $stack)
                case .detailB:
                    DetailEnumBView(stack: $stack)
                case .detailC:
                    DetailEnumCView(stack: $stack)
                }
            }
        }
    }
}

#Preview {
    StackEnumView()
}
