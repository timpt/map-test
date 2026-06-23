import SwiftUI

/// Lays out a floor's spaces inside the available area, scaling each space's
/// normalized polygon to actual points. Each space is an individually tappable
/// cell shaped to its real footprint (so gaps/corridors aren't tappable).
struct FloorPlanView: View {
    let floor: Floor
    let now: Date
    let onSelect: (Space) -> Void

    var body: some View {
        GeometryReader { proxy in
            let inset: CGFloat = 16
            let area = CGSize(
                width: max(proxy.size.width - inset * 2, 1),
                height: max(proxy.size.height - inset * 2, 1)
            )

            ZStack(alignment: .topLeading) {
                // Floor backdrop
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(.separator), lineWidth: 1)
                    )
                    .frame(width: area.width, height: area.height)
                    .position(x: proxy.size.width / 2, y: proxy.size.height / 2)

                ForEach(floor.spaces) { space in
                    let box = space.boundingBox
                    let frame = CGSize(width: box.width * area.width, height: box.height * area.height)
                    SpaceCell(
                        space: space,
                        localPoints: localPoints(for: space, box: box),
                        localCentroid: localCentroid(for: space, box: box),
                        now: now
                    )
                    .frame(width: frame.width, height: frame.height)
                    .position(
                        x: inset + (box.midX * area.width),
                        y: inset + (box.midY * area.height)
                    )
                    .onTapGesture { onSelect(space) }
                }
            }
        }
    }

    /// Polygon vertices re-normalized to the space's own bounding box (0...1).
    private func localPoints(for space: Space, box: CGRect) -> [CGPoint] {
        guard box.width > 0, box.height > 0 else { return space.polygon }
        return space.polygon.map {
            CGPoint(x: ($0.x - box.minX) / box.width, y: ($0.y - box.minY) / box.height)
        }
    }

    private func localCentroid(for space: Space, box: CGRect) -> CGPoint {
        guard box.width > 0, box.height > 0 else { return CGPoint(x: 0.5, y: 0.5) }
        let c = space.centroid
        return CGPoint(x: (c.x - box.minX) / box.width, y: (c.y - box.minY) / box.height)
    }
}

/// A single room drawn on the floor plan, tinted by its current event status.
private struct SpaceCell: View {
    let space: Space
    let localPoints: [CGPoint]
    let localCentroid: CGPoint
    let now: Date

    private var liveEvents: [Event] { space.liveEvents(at: now) }
    private var isLive: Bool { !liveEvents.isEmpty }

    private var shape: SpacePolygon { SpacePolygon(points: localPoints) }

    private var tint: Color {
        if isLive { return .red }
        if space.hasEvents { return .blue }
        return space.kind.isBookable ? .secondary : Color(.tertiaryLabel)
    }

    private var fillStyle: AnyShapeStyle {
        if isLive {
            return AnyShapeStyle(Color.red.opacity(0.18))
        } else if space.hasEvents {
            return AnyShapeStyle(Color.blue.opacity(0.14))
        } else if space.kind.isBookable {
            return AnyShapeStyle(Color(.tertiarySystemGroupedBackground))
        } else {
            return AnyShapeStyle(Color(.systemGray5))
        }
    }

    var body: some View {
        shape
            .fill(fillStyle)
            .overlay(
                shape.stroke(
                    tint.opacity(isLive ? 0.9 : 0.5),
                    style: StrokeStyle(lineWidth: isLive ? 2 : 1, lineJoin: .round)
                )
            )
            .overlay {
                GeometryReader { geo in
                    SpaceLabel(space: space)
                        .frame(maxWidth: geo.size.width - 6)
                        .position(
                            x: localCentroid.x * geo.size.width,
                            y: localCentroid.y * geo.size.height
                        )
                }
            }
            .overlay(alignment: .topLeading) {
                if isLive {
                    LiveBadge(count: liveEvents.count).padding(6)
                } else if space.hasEvents {
                    CountBadge(count: space.events.count, tint: tint).padding(6)
                }
            }
            .contentShape(shape)
    }
}

private struct SpaceLabel: View {
    let space: Space

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: space.kind.symbolName)
                .font(.system(size: 14, weight: .medium))
            Text(space.name)
                .font(.caption.weight(.medium))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
        }
        .foregroundStyle(space.kind.isBookable ? .primary : .secondary)
    }
}

private struct LiveBadge: View {
    let count: Int

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "dot.radiowaves.left.and.right")
            if count > 1 { Text("\(count)") }
        }
        .font(.caption2.bold())
        .foregroundStyle(.white)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(Capsule().fill(.red))
    }
}

private struct CountBadge: View {
    let count: Int
    let tint: Color

    var body: some View {
        Text("\(count)")
            .font(.caption2.bold())
            .foregroundStyle(.white)
            .frame(minWidth: 18, minHeight: 18)
            .background(Circle().fill(tint))
    }
}

#Preview {
    FloorPlanView(floor: SampleData.venue.floors[0], now: .now) { _ in }
        .frame(height: 500)
        .background(Color(.systemGroupedBackground))
}
