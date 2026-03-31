//
//  SettingView.swift
//  SampleApp
//
//  Created by 김동현 on 3/31/26.
//

import SwiftUI
import TurboNavigator

struct SettingView: View {
    let navigator: Navigator<AppDependencies, AppRoute>
    var body: some View {
        VStack {
            Text(String(describing: self))
        }
    }
}

#Preview {
    // 1
    SettingView(
        navigator: .preview(dependencies: (.init()))
    )

    SettingView(navigator: .preview)
    
}


//extension Navigator where Dependencies == Void {
//    
//    public convenience init(
//        registry: RouteRegistry<Void, Route>
//    ) {
//        self.init(
//            dependencies: (),
//            registry: registry
//        )
//    }
//}
