import CoreLocation

/// A hotel property shown as a pin on the map. Tapping it opens its floor maps.
struct Hotel: Identifiable, Hashable {
    let id: UUID
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var floors: [Floor]

    init(
        id: UUID = UUID(),
        name: String,
        address: String,
        latitude: Double,
        longitude: Double,
        floors: [Floor]
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.floors = floors.sorted { $0.level > $1.level }
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var eventCount: Int {
        floors.reduce(0) { $0 + $1.eventCount }
    }

    func liveEventCount(at reference: Date = .now) -> Int {
        floors.reduce(0) { $0 + $1.liveEventCount(at: reference) }
    }
}
