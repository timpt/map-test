import SwiftUI

@main
struct HotelFloorMapApp: App {
    var body: some Scene {
        WindowGroup {
            VenueFloorPlanView(venue: SampleData.venue)
        }
    }
}
