import SwiftUI

/// Wraps content with pinch-to-zoom and drag-to-pan, while leaving taps on the
/// content (e.g. selecting a room) working. A reset control appears when zoomed.
struct ZoomPanView<Content: View>: View {
    private let content: Content

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    private let minScale: CGFloat = 1
    private let maxScale: CGFloat = 4

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        let magnify = MagnifyGesture()
            .onChanged { value in
                scale = clamp(lastScale * value.magnification)
            }
            .onEnded { _ in
                lastScale = scale
                if scale <= minScale { resetPan() }
            }

        let drag = DragGesture(minimumDistance: 10)
            .onChanged { value in
                guard scale > minScale else { return }
                offset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
            }
            .onEnded { _ in lastOffset = offset }

        return content
            .scaleEffect(scale)
            .offset(offset)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(magnify.simultaneously(with: drag))
            .clipped()
            .overlay(alignment: .bottomTrailing) {
                if scale > minScale + 0.01 {
                    Button {
                        withAnimation(.snappy) { reset() }
                    } label: {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                            .font(.headline)
                            .padding(10)
                            .background(.regularMaterial, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .padding(12)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.snappy, value: scale > minScale + 0.01)
    }

    private func clamp(_ value: CGFloat) -> CGFloat {
        min(max(value, minScale), maxScale)
    }

    private func resetPan() {
        offset = .zero
        lastOffset = .zero
    }

    private func reset() {
        scale = minScale
        lastScale = minScale
        resetPan()
    }
}
