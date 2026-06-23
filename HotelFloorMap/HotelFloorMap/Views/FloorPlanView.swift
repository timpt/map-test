import SwiftUI

/// Lays out a floor's spaces inside the available area, scaling each space's
/// normalized rect to actual points. Each space is an individually tappable cell.
struct FloorPlanView: View {
    let floor: Floor
    let now: Date
    let onSelect: (Space) -> Void

    var body: some View {
        GeometryReader { proxy in
            // Keep a consistent aspect ratio for the plan, padded inside the view.
            let inset: CGFloat = 16
            let area = CGSize(
                width: proxy.size.width - inset * 2,
                height: proxy.size.height - inset * 2
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
                    let frame = scaled(space.rect, in: area)
                    SpaceCell(space: space, now: now)
                        .frame(width: frame.width, height: frame.height)
                        .position(
                            x: inset + frame.midX,
                            y: inset + frame.midY
                        )
                        .onTapGesture { onSelect(space) }
                }
            }
        }
    }

    /// Convert a normalized (0...1) rect into the floor area's point space.
    private func scaled(_ rect: CGRect, in area: CGSize) -> CGRect {
        CGRect(
            x: rect.minX * area.width,
            y: rect.minY * area.height,
            width: rect.width * area.width,
            height: rect.height * area.height
        )
    }
}

/// A single room drawn on the floor plan, tinted by its current event status.
private struct SpaceCell: View {
    let space: Space
    let now: Date

    private var liveEvents: [Event] { space.liveEvents(at: now) }
    private var isLive: Bool { !liveEvents.isEmpty }

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
        RoundedRectangle(cornerRadius: 10)
            .fill(fillStyle)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(tint.opacity(isLive ? 0.9 : 0.5), lineWidth: isLive ? 2 : 1)
            )
            .overlay(alignment: .topLeading) {
                if isLive {
                    LiveBadge(count: liveEvents.count)
                        .padding(6)
                } else if space.hasEvents {
                    CountBadge(count: space.events.count, tint: tint)
                        .padding(6)
                }
            }
            .overlay {
                SpaceLabel(space: space, tint: tint)
                    .padding(4)
            }
            .contentShape(RoundedRectangle(cornerRadius: 10))
    }
}

private struct SpaceLabel: View {
    let space: Space
    let tint: Color

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
        .padding(.horizontal, 2)
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
    FloorPlanView(floor: SampleData.grandHarbor.floors[0], now: .now) { _ in }
        .frame(height: 500)
        .background(Color(.systemGroupedBackground))
}
