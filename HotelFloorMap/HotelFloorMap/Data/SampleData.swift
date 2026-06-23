import Foundation

/// Hard-coded demo content. Events are anchored to *today* so that, depending on
/// the time of day the app is run, some spaces show "live" events.
enum SampleData {

    static let hotels: [Hotel] = [grandHarbor, summitLodge]

    // MARK: - Time helpers

    /// A `Date` today at the given hour/minute in the user's calendar.
    private static func today(_ hour: Int, _ minute: Int = 0) -> Date {
        let calendar = Calendar.current
        return calendar.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: .now
        ) ?? .now
    }

    // MARK: - Grand Harbor Hotel

    static let grandHarbor: Hotel = Hotel(
        name: "Grand Harbor Hotel",
        address: "100 Embarcadero, San Francisco, CA",
        latitude: 37.7955,
        longitude: -122.3937,
        floors: [groundFloor, conferenceFloor]
    )

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
                name: "Harbor Restaurant",
                kind: .restaurant,
                rect: CGRect(x: 0.50, y: 0.06, width: 0.44, height: 0.30),
                capacity: 120,
                events: [
                    Event(
                        title: "Breakfast Service",
                        category: .banquet,
                        start: today(7), end: today(10, 30),
                        host: "Culinary Team",
                        attendeeCount: 80,
                        notes: "Buffet-style breakfast for in-house guests."
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
                        title: "Registration & Coffee",
                        category: .social,
                        start: today(8), end: today(9),
                        host: "FinTech Forward",
                        attendeeCount: 300
                    )
                ]
            )
        ]
    )

    // MARK: - Summit Lodge

    static let summitLodge: Hotel = Hotel(
        name: "Summit Lodge & Spa",
        address: "8 Alpine Way, South Lake Tahoe, CA",
        latitude: 38.9399,
        longitude: -119.9772,
        floors: [
            Floor(
                level: 1,
                name: "Lodge Level",
                spaces: [
                    Space(
                        name: "Aspen Ballroom",
                        kind: .ballroom,
                        rect: CGRect(x: 0.06, y: 0.06, width: 0.52, height: 0.46),
                        capacity: 300,
                        events: [
                            Event(
                                title: "Alpine Tech Retreat",
                                category: .conference,
                                start: today(9, 30), end: today(16),
                                host: "Northstar Ventures",
                                attendeeCount: 160,
                                notes: "All-day offsite with breakout sessions."
                            )
                        ]
                    ),
                    Space(
                        name: "Granite Boardroom",
                        kind: .boardroom,
                        rect: CGRect(x: 0.62, y: 0.06, width: 0.32, height: 0.22),
                        capacity: 14,
                        events: [
                            Event(
                                title: "Investor Update",
                                category: .meeting,
                                start: today(14), end: today(15),
                                host: "Northstar Ventures",
                                attendeeCount: 10
                            )
                        ]
                    ),
                    Space(
                        name: "Spa & Wellness",
                        kind: .fitness,
                        rect: CGRect(x: 0.62, y: 0.32, width: 0.32, height: 0.20),
                        capacity: 30,
                        events: [
                            Event(
                                title: "Sunrise Yoga",
                                category: .fitness,
                                start: today(6, 30), end: today(7, 30),
                                host: "Wellness Studio",
                                attendeeCount: 20
                            )
                        ]
                    ),
                    Space(
                        name: "Timberline Lounge",
                        kind: .lounge,
                        rect: CGRect(x: 0.06, y: 0.58, width: 0.88, height: 0.36),
                        capacity: 90,
                        events: [
                            Event(
                                title: "Après-Ski Reception",
                                category: .social,
                                start: today(17), end: today(19, 30),
                                host: "Northstar Ventures",
                                attendeeCount: 120
                            )
                        ]
                    )
                ]
            )
        ]
    )
}
