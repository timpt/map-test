import Foundation

/// Hard-coded demo content for a single event venue. Events are anchored to
/// *today* so that, depending on the time of day the app is run, some spaces
/// show "live" events.
enum SampleData {

    static let venue = Venue(
        name: "Grand Harbor Event Center",
        subtitle: "100 Embarcadero, San Francisco",
        floors: [groundFloor, conferenceFloor]
    )

    // MARK: - Time helpers

    /// A `Date` today at the given hour/minute in the user's calendar.
    private static func today(_ hour: Int, _ minute: Int = 0) -> Date {
        Calendar.current.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: .now
        ) ?? .now
    }

    // MARK: - Ground floor

    private static let groundFloor = Floor(
        level: 0,
        name: "Ground Floor",
        spaces: [
            Space(
                name: "Main Lobby",
                kind: .lobby,
                rect: CGRect(x: 0.06, y: 0.06, width: 0.40, height: 0.30),
                capacity: 0
            ),
            Space(
                name: "Harbor Hall",
                kind: .restaurant,
                rect: CGRect(x: 0.50, y: 0.06, width: 0.44, height: 0.30),
                capacity: 120,
                events: [
                    Event(
                        title: "Breakfast & Registration",
                        category: .banquet,
                        start: today(7), end: today(9, 30),
                        host: "FinTech Forward",
                        attendeeCount: 80,
                        notes: "Buffet breakfast and badge pickup for attendees."
                    ),
                    Event(
                        title: "Wine Tasting Social",
                        category: .social,
                        start: today(18), end: today(20),
                        host: "Sommelier Guild",
                        attendeeCount: 45,
                        notes: "Featuring regional Napa Valley selections."
                    )
                ]
            ),
            Space(
                name: "Garden Lounge",
                kind: .lounge,
                rect: CGRect(x: 0.06, y: 0.42, width: 0.40, height: 0.30),
                capacity: 60,
                events: [
                    Event(
                        title: "Afternoon Networking",
                        category: .social,
                        start: today(15), end: today(17),
                        host: "Bay Area Founders",
                        attendeeCount: 50
                    )
                ]
            ),
            Space(
                name: "Pacific Ballroom",
                kind: .ballroom,
                rect: CGRect(x: 0.50, y: 0.42, width: 0.44, height: 0.52),
                capacity: 400,
                events: [
                    Event(
                        title: "Patel–Nguyen Wedding",
                        category: .wedding,
                        start: today(16), end: today(23),
                        host: "Events by Aria",
                        attendeeCount: 220,
                        notes: "Ceremony at 4:30 PM, reception to follow."
                    )
                ]
            ),
            Space(
                name: "Back of House",
                kind: .service,
                rect: CGRect(x: 0.06, y: 0.78, width: 0.40, height: 0.16),
                capacity: 0
            )
        ]
    )

    // MARK: - Conference floor

    private static let conferenceFloor = Floor(
        level: 2,
        name: "Conference Level",
        spaces: [
            Space(
                name: "Summit Hall A",
                kind: .ballroom,
                rect: CGRect(x: 0.06, y: 0.06, width: 0.44, height: 0.40),
                capacity: 250,
                events: [
                    Event(
                        title: "FinTech Forward Keynote",
                        category: .conference,
                        start: today(9), end: today(12),
                        host: "FinTech Forward",
                        attendeeCount: 210,
                        notes: "Opening keynote and morning panels."
                    ),
                    Event(
                        title: "Partner Awards Banquet",
                        category: .banquet,
                        start: today(19), end: today(22),
                        host: "FinTech Forward",
                        attendeeCount: 180
                    )
                ]
            ),
            Space(
                name: "Summit Hall B",
                kind: .ballroom,
                rect: CGRect(x: 0.54, y: 0.06, width: 0.40, height: 0.40),
                capacity: 200,
                events: [
                    Event(
                        title: "Developer Workshop",
                        category: .workshop,
                        start: today(10), end: today(13),
                        host: "API Platform Team",
                        attendeeCount: 90,
                        notes: "Hands-on lab — bring a laptop."
                    )
                ]
            ),
            Space(
                name: "Cypress Boardroom",
                kind: .boardroom,
                rect: CGRect(x: 0.06, y: 0.52, width: 0.26, height: 0.24),
                capacity: 16,
                events: [
                    Event(
                        title: "Board of Directors",
                        category: .meeting,
                        start: today(11), end: today(12, 30),
                        host: "Executive Office",
                        attendeeCount: 12
                    )
                ]
            ),
            Space(
                name: "Redwood Room",
                kind: .meetingRoom,
                rect: CGRect(x: 0.36, y: 0.52, width: 0.26, height: 0.24),
                capacity: 40,
                events: [
                    Event(
                        title: "Product Strategy Sync",
                        category: .meeting,
                        start: today(13), end: today(14, 30),
                        host: "Product Org",
                        attendeeCount: 28
                    )
                ]
            ),
            Space(
                name: "Bayview Room",
                kind: .meetingRoom,
                rect: CGRect(x: 0.66, y: 0.52, width: 0.28, height: 0.24),
                capacity: 40
            ),
            Space(
                name: "Pre-Function Foyer",
                kind: .lounge,
                rect: CGRect(x: 0.06, y: 0.80, width: 0.88, height: 0.14),
                capacity: 150,
                events: [
                    Event(
                        title: "Coffee & Networking Break",
                        category: .social,
                        start: today(8), end: today(9),
                        host: "FinTech Forward",
                        attendeeCount: 300
                    )
                ]
            )
        ]
    )
}
