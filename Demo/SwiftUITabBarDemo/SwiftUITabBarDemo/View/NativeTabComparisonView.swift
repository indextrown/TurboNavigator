import SwiftUI

struct NativeTabComparisonView: View {
    var body: some View {
        TabView {
            NativeSampleTab(
                title: "First",
                subtitle: "SwiftUI 기본 TabView 첫 번째 화면",
                color: .red
            )
            .tabItem {
                Label("First", systemImage: "1.circle.fill")
            }

            NativeSampleTab(
                title: "Second",
                subtitle: "SwiftUI 기본 TabView 두 번째 화면",
                color: .green
            )
            .tabItem {
                Label("Second", systemImage: "2.circle.fill")
            }

            NativeSampleTab(
                title: "Third",
                subtitle: "SwiftUI 기본 TabView 세 번째 화면",
                color: .blue
            )
            .tabItem {
                Label("Third", systemImage: "3.circle.fill")
            }

            NativeSampleTab(
                title: "Fourth",
                subtitle: "SwiftUI 기본 TabView 네 번째 화면",
                color: .orange
            )
            .tabItem {
                Label("Fourth", systemImage: "4.circle.fill")
            }
        }
        .tint(.primary)
    }
}

private struct NativeSampleTab: View {
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        ZStack {
            color.opacity(0.18)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Text(title)
                    .font(.largeTitle.weight(.bold))

                Text(subtitle)
                    .foregroundStyle(.secondary)
            }
            .padding(24)
        }
    }
}
