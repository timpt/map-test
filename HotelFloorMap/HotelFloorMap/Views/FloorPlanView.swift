import SwiftUI

/// Renders a floor's real plan drawing (`floor.imageName`) and overlays a
/// tappable hotspot on each space, aligned to the drawing. Spaces with live or
/// scheduled events are tinted; the room names come from the drawing itself.
struct FloorPlanView: View {
    let floor: Floor
    let now: Date
    let onSelect: (Space) -> Void

    /// Pixel size of the bundled floor-plan image; hotspot polygons are
    /// normalized against this exact frame, so the overlay stays aligned.
    private let planAspect: CGFloat = 2766.0 / 1844.0

    var body: some View {
        GeometryReader { proxy in
            let rect = fittedPlanRect(in: proxy.size)

            ZStack(alignment: .topLeading) {
                if let imageName = floor.imageName {
                    Image(imageName)
                        .resizable()
                        .interpolation(.high)
                        .frame(width: rect.width, height: rect.height)
                        .position(x: rect.midX, y: rect.midY)
                }

                ForEach(floor.spaces) { space in
                    let box = space.boundingBox
                    RoomHotspot(
                        space: space,
                        localPoints: localPoints(for: space, box: box),
                        now: now
                    )
                    .frame(width: box.width * rect.width, height: box.height * rect.height)
                    .position(
                        x: rect.minX + box.midX * rect.width,
                        y: rect.minY + box.midY * rect.height
                    )
                    .onTapGesture { onSelect(space) }
                }
            }
        }
    }

    /// The aspect-fit rectangle the plan image occupies within `size`.
    private func fittedPlanRect(in size: CGSize) -> CGRect {
        var width = size.width
        var height = size.width / planAspect
        if height > size.height {
            height = size.height
            width = size.height * planAspect
        }
        return CGRect(
            x: (size.width - width) / 2,
            y: (size.height - height) / 2,
            width: width,
            height: height
        )
    }

    /// Polygon vertices re-normalized to the space's own bounding box (0...1).
    private func localPoints(for space: Space, box: CGRect) -> [CGPoint] {
        guard box.width > 0, box.height > 0 else { return space.polygon }
        return space.polygon.map {
            CGPoint(x: ($0.x - box.minX) / box.width, y: ($0.y - box.minY) / box.height)
        }
    }
}

/// A single tappable room overlay, tinted by its current event status. Drawn
/// translucent so the underlying floor-plan drawing (and room name) shows.
private struct RoomHotspot: View {
    let space: Space
    let localPoints: [CGPoint]
    let now: Date

    private var liveEvents: [Event] { space.liveEvents(at: now) }
    private var isLive: Bool { !liveEvents.isEmpty }
    private var shape: SpacePolygon { SpacePolygon(points: localPoints) }

    private var tint: Color {
        if isLive { return .red }
        if space.hasEvents { return .blue }
        return .clear
    }

    private var fillOpacity: Double {
        if isLive { return 0.30 }
        if space.hasEvents { return 0.16 }
        return 0.001 // effectively invisible, but keeps the area tappable
    }

    var body: some View {
        shape
            .fill(tint.opacity(fillOpacity))
            .overlay {
                if tint != .clear {
                    shape.stroke(tint.opacity(0.9), style: StrokeStyle(lineWidth: isLive ? 2.5 : 1.5, lineJoin: .round))
                }
            }
            .overlay(alignment: .topLeading) {
                if isLive {
                    LiveBadge(count: liveEvents.count).padding(3)
                }
            }
            .contentShape(shape)
    }
}

private struct LiveBadge: View {
    let count: Int

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "dot.radiowaves.left.and.right")
            if count > 1 { Text("\(count)") }
        }
        .font(.system(size: 10, weight: .bold))
        .foregroundStyle(.white)
        .padding(.horizontal, 5)
        .padding(.vertical, 2)
        .background(Capsule().fill(.red))
        .shadow(radius: 1)
    }
}

#Preview {
    FloorPlanView(floor: SampleData.venue.floors[0], now: .now) { _ in }
        .background(Color(.systemBackground))
}
