//
//  ContentView.swift
//  TurboNavigatorDemo
//
//  Created by 김동현 on 3/29/26.
//

import SwiftUI
import TurboNavigator

enum MyRouter: Router {
    enum Path: Hashable {
        case detail
        case detail2
    }
    
    @ViewBuilder
    static func build(path: MyRouter.Path) -> some View {
        switch path {
        case .detail:
            DetailView()
        case .detail2:
            DetailView2()
        }
    }
}

struct ContentView: View {
    @StateObject private var coordinator = Coordinator<MyRouter>()
    var body: some View {
        print("🔥 ContentView body")
        return CoordinatorContainer(coordinator: coordinator) {
            VStack {
                Button {
                    coordinator.route(.push(.detail))
                    print()
                } label: {
                    Text("Detail 이동")
                }
            }
        }
    }
}

struct DetailView: View {
    @EnvironmentObject private var coordinator: Coordinator<MyRouter>
    var body: some View {
        print("🔥 DetailView body")
        
        return VStack {
            Text("\(String(describing: self))")
            
            Button {
                coordinator.route(.push(.detail2))
                print()
            } label: {
                Text("Detail2 이동")
            }
        }
    }
}

struct DetailView2: View {
    var body: some View {
        print("🔥 DetailView2 body")
        return Text("\(String(describing: self))")
    }
}

#Preview {
    ContentView()
}

