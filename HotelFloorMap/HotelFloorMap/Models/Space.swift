import SwiftUI

/// A physical, bookable space on a hotel floor (ballroom, meeting room, lobby, …).
///
/// `rect` describes the room's footprint in the floor's *normalized* coordinate
/// space (0...1 on both axes), so the floor plan renders crisply at any size.
struct Space: Identifiable, Hashable {
    let id: UUID
    var name: String
    var kind: Kind
    var rect: CGRect
    var capacity: Int
    var events: [Event]

    init(
        id: UUID = UUID(),
        name: String,
        kind: Kind,
        rect: CGRect,
        capacity: Int,
        events: [Event] = []
    ) {
        self.id = id
        self.name = name
        self.kind = kind
        self.rect = rect
        self.capacity = capacity
        self.events = events.sorted { $0.start < $1.start }
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

    var hasEvents: Bool { !events.isEmpty }
}
