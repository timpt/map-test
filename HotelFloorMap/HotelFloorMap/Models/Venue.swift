import Foundation

/// A single event venue (hotel, conference center, …) made up of one or more
/// floors. This is the root of the data model the app displays.
struct Venue: Identifiable, Hashable {
    let id: UUID
    var name: String
    var subtitle: String
    var floors: [Floor]

    init(id: UUID = UUID(), name: String, subtitle: String, floors: [Floor]) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.floors = floors.sorted { $0.level > $1.level }
    }

    var eventCount: Int {
        floors.reduce(0) { $0 + $1.eventCount }
    }

    func liveEventCount(at reference: Date = .now) -> Int {
        floors.reduce(0) { $0 + $1.liveEventCount(at: reference) }
    }
}
