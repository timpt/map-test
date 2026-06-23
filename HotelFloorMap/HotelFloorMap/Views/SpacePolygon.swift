import SwiftUI

/// Draws a closed polygon whose vertices are given in *local* normalized
/// coordinates (0...1 relative to the shape's frame). Used both to render a
/// room and to define its tappable hit area via `.contentShape`.
struct SpacePolygon: Shape {
    /// Vertices normalized to 0...1 within this shape's own rect.
    let points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        Path { path in
            guard let first = points.first else { return }
            path.move(to: point(first, in: rect))
            for vertex in points.dropFirst() {
                path.addLine(to: point(vertex, in: rect))
            }
            path.closeSubpath()
        }
    }

    private func point(_ p: CGPoint, in rect: CGRect) -> CGPoint {
        CGPoint(x: rect.minX + p.x * rect.width, y: rect.minY + p.y * rect.height)
    }
}
