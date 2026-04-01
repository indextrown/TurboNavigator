//
//  TestAppApp.swift
//  TestApp
//
//  Created by 김동현 on 4/1/26.
//

import SwiftUI

@main
struct TestAppApp: App {
    var body: some Scene {
        WindowGroup {
            // ContentView()
            // StackView()
            //  StackEnumView()
            NavigationContainer {
                HomeView()
            }
        }
    }
}
