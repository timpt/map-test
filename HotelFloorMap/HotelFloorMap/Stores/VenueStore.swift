import Observation

/// Holds the venue as mutable state so the UI can add events ("book" a space)
/// and have the floor plan update live.
@Observable
final class VenueStore {
    var venue: Venue

    init(venue: Venue) {
        self.venue = venue
    }

    /// Look up a space by id across all floors.
    func space(id: Space.ID) -> Space? {
        for floor in venue.floors {
            if let match = floor.spaces.first(where: { $0.id == id }) {
                return match
            }
        }
        return nil
    }

    /// Add an event to the given space, keeping the space's events time-sorted.
    func addEvent(_ event: Event, toSpaceID spaceID: Space.ID) {
        for floorIndex in venue.floors.indices {
            guard let spaceIndex = venue.floors[floorIndex].spaces
                .firstIndex(where: { $0.id == spaceID }) else { continue }
            venue.floors[floorIndex].spaces[spaceIndex].events.append(event)
            venue.floors[floorIndex].spaces[spaceIndex].events.sort { $0.start < $1.start }
            return
        }
    }
}
