//
//  ContentView.swift
//  TestApp
//
//  Created by 김동현 on 4/1/26.
//
// https://green1229.tistory.com/256

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        NavigationStack {
            // Root: 처음 보여주는 View
            List {
                NavigationLink("Go to Child View", value: "10")
            }
            // Data: path에 쌓이는 값 타입
            .navigationDestination(for: String.self) { value in
                Text("Child Number is \(value)")
            }
        }
    }
}

//#Preview {
//    ContentView()
//}



//struct StackView: View {
//    @State var stack = NavigationPath()
//
//    var body: some View {
//        NavigationStack(path: $stack) {
//            NavigationLink("Go to Child View", value: 10)
//                .navigationDestination(for: Int.self) { value in
//                    Text("Child Number is \(value)")
//                    Button("Go to Root View") {
//                        stack.removeLast()
//                    }
//                }
//        }
//    }
//}
