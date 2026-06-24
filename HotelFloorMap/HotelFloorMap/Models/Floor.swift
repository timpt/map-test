import Foundation

/// A single floor (level) of a hotel, containing the spaces laid out on it.
struct Floor: Identifiable, Hashable {
    let id: UUID
    var level: Int
    var name: String
    /// Asset-catalog image of this floor's walls + labels (a lightened version of
    /// the real plan drawing), laid over the room fills. Space polygons are
    /// expressed in this image's normalized (0...1) coordinate space. When nil,
    /// only the room fills are drawn.
    var imageName: String?
    var spaces: [Space]

    init(id: UUID = UUID(), level: Int, name: String, imageName: String? = nil, spaces: [Space]) {
        self.id = id
        self.level = level
        self.name = name
        self.imageName = imageName
        self.spaces = spaces
    }

    var shortName: String {
        switch level {
        case 0: return "G"
        default: return "\(level)"
        }
    }

    /// Total number of events scheduled across every space on the floor.
    var eventCount: Int {
        spaces.reduce(0) { $0 + $1.events.count }
    }

    func liveEventCount(at reference: Date = .now) -> Int {
        spaces.reduce(0) { $0 + $1.liveEvents(at: reference).count }
    }
}
