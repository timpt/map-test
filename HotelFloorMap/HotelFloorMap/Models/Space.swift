import SwiftUI

/// A physical, bookable space on a hotel floor (ballroom, meeting room, lobby, …).
///
/// `polygon` describes the room's footprint as vertices in the floor's
/// *normalized* coordinate space (0...1 on both axes), so the floor plan renders
/// crisply at any size and supports non-rectangular (e.g. L-shaped) rooms.
struct Space: Identifiable, Hashable {
    let id: UUID
    var name: String
    var kind: Kind
    var polygon: [CGPoint]
    var capacity: Int
    var events: [Event]

    /// Designated initializer taking an explicit polygon.
    init(
        id: UUID = UUID(),
        name: String,
        kind: Kind,
        polygon: [CGPoint],
        capacity: Int,
        events: [Event] = []
    ) {
        self.id = id
        self.name = name
        self.kind = kind
        self.polygon = polygon
        self.capacity = capacity
        self.events = events.sorted { $0.start < $1.start }
    }

    /// Convenience initializer for the common case of a rectangular room.
    init(
        id: UUID = UUID(),
        name: String,
        kind: Kind,
        rect: CGRect,
        capacity: Int,
        events: [Event] = []
    ) {
        let corners = [
            CGPoint(x: rect.minX, y: rect.minY),
            CGPoint(x: rect.maxX, y: rect.minY),
            CGPoint(x: rect.maxX, y: rect.maxY),
            CGPoint(x: rect.minX, y: rect.maxY)
        ]
        self.init(id: id, name: name, kind: kind, polygon: corners, capacity: capacity, events: events)
    }

    enum Kind: String, Hashable {
        case ballroom = "Ballroom"
        case meetingRoom = "Meeting Room"
        case boardroom = "Boardroom"
        case lounge = "Lounge"
        case restaurant = "Restaurant"
        case lobby = "Lobby"
        case fitness = "Fitness"
        case service = "Service"

        var symbolName: String {
            switch self {
            case .ballroom: return "sparkles"
            case .meetingRoom: return "rectangle.inset.filled"
            case .boardroom: return "tablecells"
            case .lounge: return "sofa.fill"
            case .restaurant: return "fork.knife"
            case .lobby: return "door.left.hand.open"
            case .fitness: return "dumbbell.fill"
            case .service: return "gearshape.fill"
            }
        }

        /// Whether this kind of space can host scheduled events.
        var isBookable: Bool {
            switch self {
            case .lobby, .service: return false
            default: return true
            }
        }
    }

    func liveEvents(at reference: Date = .now) -> [Event] {
        events.filter { $0.isLive(at: reference) }
    }

    func upcomingEvents(at reference: Date = .now) -> [Event] {
        events.filter { $0.isUpcoming(at: reference) }
    }

    /// The event underway at `reference`, if any (rooms hold one at a time).
    func event(at reference: Date) -> Event? {
        events.first { $0.isLive(at: reference) }
    }

    /// Whether a session is taking place in this space at `reference`.
    func isBusy(at reference: Date) -> Bool {
        event(at: reference) != nil
    }

    var hasEvents: Bool { !events.isEmpty }

    // MARK: - Geometry

    /// The axis-aligned bounding box of the polygon, in normalized coordinates.
    var boundingBox: CGRect {
        guard let first = polygon.first else { return .zero }
        var minX = first.x, minY = first.y, maxX = first.x, maxY = first.y
        for p in polygon {
            minX = min(minX, p.x); minY = min(minY, p.y)
            maxX = max(maxX, p.x); maxY = max(maxY, p.y)
        }
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }

    /// Area-weighted centroid, used to place the room label. Falls back to the
    /// bounding-box center for degenerate polygons.
    var centroid: CGPoint {
        guard polygon.count > 2 else {
            let box = boundingBox
            return CGPoint(x: box.midX, y: box.midY)
        }
        var area: CGFloat = 0, cx: CGFloat = 0, cy: CGFloat = 0
        for i in polygon.indices {
            let a = polygon[i]
            let b = polygon[(i + 1) % polygon.count]
            let cross = a.x * b.y - b.x * a.y
            area += cross
            cx += (a.x + b.x) * cross
            cy += (a.y + b.y) * cross
        }
        area *= 0.5
        guard abs(area) > 1e-9 else {
            let box = boundingBox
            return CGPoint(x: box.midX, y: box.midY)
        }
        return CGPoint(x: cx / (6 * area), y: cy / (6 * area))
    }
}
