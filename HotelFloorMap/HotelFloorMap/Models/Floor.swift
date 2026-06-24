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

    /// Number of spaces with a session underway at `reference`.
    func busyCount(at reference: Date) -> Int {
        spaces.reduce(0) { $0 + ($1.isBusy(at: reference) ? 1 : 0) }
    }

    /// Events scheduled on the same calendar day as `reference`.
    func eventCount(on reference: Date) -> Int {
        let calendar = Calendar.current
        return spaces
            .flatMap(\.events)
            .filter { calendar.isDate($0.start, inSameDayAs: reference) }
            .count
    }

    /// Distinct days (each at start-of-day) that have at least one event, ascending.
    /// Drives the day selector in the time scrubber.
    var eventDays: [Date] {
        let calendar = Calendar.current
        let days = Set(spaces.flatMap(\.events).map { calendar.startOfDay(for: $0.start) })
        return days.sorted()
    }

    /// The earliest start and latest end across all events, used to bound the
    /// time slider. `nil` when the floor has no events.
    var eventTimeSpan: ClosedRange<Date>? {
        let events = spaces.flatMap(\.events)
        guard let first = events.map(\.start).min(),
              let last = events.map(\.end).max() else { return nil }
        return first...last
    }
}
