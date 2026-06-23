import SwiftUI

/// A reusable rounded "card" background that uses the iOS 26 Liquid Glass
/// material where available and falls back to a regular material otherwise.
private struct GlassCardBackground: ViewModifier {
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(
                    .regular,
                    in: .rect(cornerRadius: cornerRadius)
                )
        } else {
            content
                .background(.ultraThinMaterial, in: .rect(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2), radius: 12, y: 4)
        }
    }
}

extension View {
    /// Applies a glass / material card background suitable for floating overlays.
    func glassCardBackground(cornerRadius: CGFloat = 20) -> some View {
        modifier(GlassCardBackground(cornerRadius: cornerRadius))
    }
}
