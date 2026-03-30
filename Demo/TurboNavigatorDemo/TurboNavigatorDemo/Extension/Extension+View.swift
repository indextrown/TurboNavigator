//
//  Extension+View.swift
//  TurboNavigatorDemo
//
//  Created by 김동현 on 3/31/26.
//

import SwiftUI

extension View {
    /*
     section(
       title: "Stack",
       content: {
         View1
         View2
         View3
       }
     )
     
     ->
     
     VStack {
       Text("Stack")

       VStack {   // ← ViewBuilder가 묶어줌
         demoButton(...)
         demoButton(...)
         demoButton(...)
       }
     }
     */
    @ViewBuilder
    func section<Content: View, Footer: View>(
        _ title: String,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
            footer()
        }
    }
    
    func demoButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
