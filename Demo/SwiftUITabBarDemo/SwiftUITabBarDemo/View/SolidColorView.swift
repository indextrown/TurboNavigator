import SwiftUI

struct SolidColorView: View {
    let title: String
    let color: Color

    var body: some View {
        ZStack {
            color
                .ignoresSafeArea()

            Text(title)
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.white)
        }
    }
}
