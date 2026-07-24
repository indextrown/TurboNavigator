import SwiftUI

public struct DemoScreen<Content: View>: View {
    private let eyebrow: String
    private let title: String
    private let summary: String
    private let accent: Color
    private let content: Content

    public init(
        eyebrow: String,
        title: String,
        summary: String,
        accent: Color,
        @ViewBuilder content: () -> Content
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.summary = summary
        self.accent = accent
        self.content = content()
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(eyebrow.uppercased())
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .tracking(1.8)
                        .foregroundStyle(accent)

                    Text(title)
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundStyle(.primary)

                    Text(summary)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                content
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 28)
        }
        .background {
            ZStack(alignment: .topTrailing) {
                Color(uiColor: .systemGroupedBackground)

                Circle()
                    .fill(accent.opacity(0.16))
                    .frame(width: 280, height: 280)
                    .blur(radius: 12)
                    .offset(x: 120, y: -120)
            }
            .ignoresSafeArea()
        }
    }
}

public struct DemoActionButton: View {
    private let title: String
    private let subtitle: String
    private let systemImage: String
    private let tint: Color
    private let action: () -> Void

    public init(
        _ title: String,
        subtitle: String,
        systemImage: String,
        tint: Color,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.tint = tint
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: systemImage)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(tint, in: RoundedRectangle(cornerRadius: 13, style: .continuous))

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 8)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(tint.opacity(0.16), lineWidth: 1)
            }
        }
        .accessibilityLabel(title)
        .accessibilityIdentifier(title)
        .buttonStyle(.plain)
    }
}

public struct DemoInfoCard: View {
    private let title: String
    private let value: String
    private let tint: Color

    public init(title: String, value: String, tint: Color) {
        self.title = title
        self.value = value
        self.tint = tint
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.system(.caption2, design: .rounded, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(tint)

            Text(value)
                .font(.system(.callout, design: .monospaced, weight: .medium))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(tint.opacity(0.1))
        )
    }
}
