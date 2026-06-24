import SwiftUI

/// Renders the floor as a familiar indoor-map: each room is filled by event
/// status, and the venue's real walls + labels (a lightened drawing in
/// `floor.imageName`) are laid over the top, so the map stays geometrically
/// accurate while reading like a styled indoor map.
struct FloorPlanView: View {
    let floor: Floor
    let now: Date
    /// The currently selected room, highlighted above the walls layer.
    var selectedSpaceID: Space.ID?
    /// When true (the map is pinned to the live clock), busy rooms gently pulse
    /// to signal they're happening *right now* rather than at a scrubbed time.
    var emphasizeLive: Bool = false
    let onSelect: (Space) -> Void

    /// Pixel aspect of the bundled walls image; room polygons are normalized
    /// against this exact frame so fills line up under the walls.
    private let planAspect: CGFloat = 2766.0 / 1844.0

    var body: some View {
        GeometryReader { proxy in
            let rect = fittedPlanRect(in: proxy.size)

            ZStack(alignment: .topLeading) {
                // Room fills (tappable), beneath the walls.
                ForEach(floor.spaces) { space in
                    let box = space.boundingBox
                    RoomFill(
                        space: space,
                        localPoints: localPoints(for: space, box: box),
                        now: now,
                        emphasizeLive: emphasizeLive
                    )
                    .frame(width: box.width * rect.width, height: box.height * rect.height)
                    .position(
                        x: rect.minX + box.midX * rect.width,
                        y: rect.minY + box.midY * rect.height
                    )
                    .onTapGesture { onSelect(space) }
                }

                // Real walls + labels on top; never intercepts taps.
                if let imageName = floor.imageName {
                    Image(imageName)
                        .resizable()
                        .interpolation(.high)
                        .frame(width: rect.width, height: rect.height)
                        .position(x: rect.midX, y: rect.midY)
                        .allowsHitTesting(false)
                }

                // Selection highlight, drawn above the walls so the accent ring
                // is never obscured by the wall drawing.
                if let space = floor.spaces.first(where: { $0.id == selectedSpaceID }) {
                    let box = space.boundingBox
                    SelectionHighlight(localPoints: localPoints(for: space, box: box))
                        .frame(width: box.width * rect.width, height: box.height * rect.height)
                        .position(
                            x: rect.minX + box.midX * rect.width,
                            y: rect.minY + box.midY * rect.height
                        )
                        .allowsHitTesting(false)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.18), value: selectedSpaceID)
        }
    }

    /// The aspect-fit rectangle the plan occupies within `size`.
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

/// Shared colors for the two map states. The map answers one question for an
/// attendee — "is something on in this room right now?" — so rooms are either
/// `busy` (a session is underway at the viewed time) or `quiet`.
enum MapStyle {
    static let busy = Color(red: 0.42, green: 0.65, blue: 0.97)
    static let quiet = Color.white.opacity(0.55)
}

/// A room filled by whether it's busy at the viewed time, under the walls layer.
private struct RoomFill: View {
    let space: Space
    let localPoints: [CGPoint]
    /// The time the map is currently showing (driven by the scrubber).
    let now: Date
    let emphasizeLive: Bool

    @State private var pulsing = false

    private var isBusy: Bool { space.isBusy(at: now) }
    private var shape: SpacePolygon { SpacePolygon(points: localPoints) }
    private var fill: Color { isBusy ? MapStyle.busy : MapStyle.quiet }

    /// Pulse only live-right-now rooms, so a scrubbed snapshot stays static.
    private var shouldPulse: Bool { isBusy && emphasizeLive }

    var body: some View {
        shape
            .fill(fill)
            .opacity(shouldPulse && pulsing ? 0.65 : 1)
            .contentShape(shape)
            .onChange(of: shouldPulse, initial: true) { _, active in
                pulsing = false
                guard active else { return }
                withAnimation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true)) {
                    pulsing = true
                }
            }
    }
}

/// An accent ring + soft tint over the selected room, sitting above the walls.
private struct SelectionHighlight: View {
    let localPoints: [CGPoint]

    private var shape: SpacePolygon { SpacePolygon(points: localPoints) }

    var body: some View {
        shape
            .fill(Color.accentColor.opacity(0.16))
            .overlay(shape.stroke(Color.accentColor, lineWidth: 3))
            .shadow(color: Color.accentColor.opacity(0.35), radius: 5)
    }
}

#Preview {
    FloorPlanView(
        floor: SampleData.venue.floors[0],
        now: .now,
        selectedSpaceID: SampleData.venue.floors[0].spaces.first?.id
    ) { _ in }
    .background(Color(red: 0.949, green: 0.941, blue: 0.918))
}
