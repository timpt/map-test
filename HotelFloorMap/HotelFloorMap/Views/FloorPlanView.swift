import SwiftUI

/// Custom, fully app-drawn indoor map: the venue's real building footprint
/// (derived from the plan, `floor.imageName`) sits on a warm background, with
/// each room drawn on top as a styled, labeled, status-colored shape.
struct FloorPlanView: View {
    let floor: Floor
    let now: Date
    let onSelect: (Space) -> Void

    /// Pixel aspect of the footprint image; room polygons are normalized against
    /// this exact frame so they sit correctly inside the building outline.
    private let planAspect: CGFloat = 2766.0 / 1844.0

    var body: some View {
        GeometryReader { proxy in
            let rect = fittedPlanRect(in: proxy.size)

            ZStack(alignment: .topLeading) {
                // Building footprint (the "floor"), beneath everything.
                if let imageName = floor.imageName {
                    Image(imageName)
                        .resizable()
                        .interpolation(.high)
                        .frame(width: rect.width, height: rect.height)
                        .position(x: rect.midX, y: rect.midY)
                        .allowsHitTesting(false)
                }

                // Rooms drawn on top of the floor.
                ForEach(floor.spaces) { space in
                    let box = space.boundingBox
                    RoomCell(
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

    private func localPoints(for space: Space, box: CGRect) -> [CGPoint] {
        guard box.width > 0, box.height > 0 else { return space.polygon }
        return space.polygon.map {
            CGPoint(x: ($0.x - box.minX) / box.width, y: ($0.y - box.minY) / box.height)
        }
    }
}

/// A single room: status-colored fill, white separator, centered label.
private struct RoomCell: View {
    let space: Space
    let localPoints: [CGPoint]
    let now: Date

    private var isLive: Bool { !space.liveEvents(at: now).isEmpty }
    private var shape: SpacePolygon { SpacePolygon(points: localPoints) }

    private var fill: Color {
        if isLive { return Color(red: 0.97, green: 0.81, blue: 0.78) }
        if space.hasEvents { return Color(red: 0.81, green: 0.88, blue: 0.97) }
        return .white
    }

    private var labelColor: Color {
        if isLive { return Color(red: 0.66, green: 0.21, blue: 0.16) }
        if space.hasEvents { return Color(red: 0.11, green: 0.31, blue: 0.61) }
        return Color(red: 0.36, green: 0.36, blue: 0.38)
    }

    var body: some View {
        shape
            .fill(fill)
            .overlay(shape.stroke(.white, style: StrokeStyle(lineWidth: 2.5, lineJoin: .round)))
            .overlay {
                VStack(spacing: 2) {
                    if isLive {
                        Circle().fill(.red).frame(width: 6, height: 6)
                    }
                    Text(space.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(labelColor)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.4)
                        .lineLimit(2)
                }
                .padding(3)
            }
            .contentShape(shape)
    }
}

#Preview {
    FloorPlanView(floor: SampleData.venue.floors[0], now: .now) { _ in }
        .background(Color(red: 0.925, green: 0.918, blue: 0.894))
}
