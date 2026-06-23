import SwiftUI

/// Demo content modeled on the **JW Marriott Reston Station** (Reston, VA).
///
/// Room names, sizes and the single-event-level layout are based on the
/// venue's publicly listed event spaces (Luminary Ballroom, Jewel Box, Blank
/// Canvas, ~40,000 sq ft on one level). Exact room geometry and the breakout
/// "Studio" rooms are approximate — the official interactive floor plan isn't
/// publicly available. Events are illustrative and anchored to *today* so that
/// "live" highlighting reflects the actual time of day the app is run.
enum SampleData {

    static let venue = Venue(
        name: "JW Marriott Reston Station",
        subtitle: "1900 Reston Metro Plaza, Reston, VA",
        floors: [eventLevel, lobbyLevel]
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

    // MARK: - Event Level (~40,000 sq ft of meeting space, single level)

    private static let eventLevel = Floor(
        level: 2,
        name: "Event Level",
        spaces: [
            // Luminary Ballroom — divisible into three salons.
            Space(
                name: "Luminary Salon I",
                kind: .ballroom,
                rect: CGRect(x: 0.05, y: 0.05, width: 0.29, height: 0.34),
                capacity: 200,
                events: [
                    Event(
                        title: "Northern Virginia Tech Summit",
                        category: .conference,
                        start: today(9), end: today(12),
                        host: "NoVA Tech Council",
                        attendeeCount: 180,
                        notes: "Opening keynote and morning general sessions."
                    ),
                    Event(
                        title: "Innovation Awards Gala",
                        category: .banquet,
                        start: today(19), end: today(22, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 320,
                        notes: "Seated dinner across the full Luminary Ballroom."
                    )
                ]
            ),
            Space(
                name: "Luminary Salon II",
                kind: .ballroom,
                rect: CGRect(x: 0.355, y: 0.05, width: 0.29, height: 0.34),
                capacity: 200,
                events: [
                    Event(
                        title: "Cloud Infrastructure Track",
                        category: .conference,
                        start: today(13), end: today(15, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 150,
                        notes: "Afternoon breakout track."
                    )
                ]
            ),
            Space(
                name: "Luminary Salon III",
                kind: .ballroom,
                rect: CGRect(x: 0.66, y: 0.05, width: 0.29, height: 0.34),
                capacity: 200,
                events: [
                    Event(
                        title: "Sponsor & Vendor Expo",
                        category: .social,
                        start: today(10), end: today(16),
                        host: "NoVA Tech Council",
                        attendeeCount: 250,
                        notes: "Exhibitor booths open throughout the day."
                    )
                ]
            ),
            // Pre-function space serving the ballroom.
            Space(
                name: "Grand Foyer",
                kind: .lounge,
                rect: CGRect(x: 0.05, y: 0.42, width: 0.90, height: 0.09),
                capacity: 300,
                events: [
                    Event(
                        title: "Registration & Coffee",
                        category: .social,
                        start: today(8), end: today(9),
                        host: "NoVA Tech Council",
                        attendeeCount: 400
                    )
                ]
            ),
            // Junior ballroom.
            Space(
                name: "Jewel Box",
                kind: .ballroom,
                rect: CGRect(x: 0.05, y: 0.55, width: 0.27, height: 0.25),
                capacity: 250,
                events: [
                    Event(
                        title: "Ramirez–Cole Wedding",
                        category: .wedding,
                        start: today(17), end: today(23),
                        host: "Events by Lumen",
                        attendeeCount: 160,
                        notes: "Ceremony at 5:00 PM, reception to follow."
                    )
                ]
            ),
            Space(
                name: "Blank Canvas",
                kind: .meetingRoom,
                rect: CGRect(x: 0.34, y: 0.55, width: 0.22, height: 0.25),
                capacity: 80,
                events: [
                    Event(
                        title: "Product Design Workshop",
                        category: .workshop,
                        start: today(10), end: today(13),
                        host: "Studio North",
                        attendeeCount: 45,
                        notes: "Hands-on session — materials provided."
                    )
                ]
            ),
            Space(
                name: "Studio A",
                kind: .meetingRoom,
                rect: CGRect(x: 0.58, y: 0.55, width: 0.17, height: 0.115),
                capacity: 40,
                events: [
                    Event(
                        title: "Investor Roundtable",
                        category: .meeting,
                        start: today(11), end: today(12, 30),
                        host: "Meridian Ventures",
                        attendeeCount: 24
                    )
                ]
            ),
            Space(
                name: "Studio B",
                kind: .meetingRoom,
                rect: CGRect(x: 0.58, y: 0.675, width: 0.17, height: 0.125),
                capacity: 40,
                events: [
                    Event(
                        title: "Press Briefing",
                        category: .meeting,
                        start: today(14), end: today(15),
                        host: "NoVA Tech Council",
                        attendeeCount: 30
                    )
                ]
            ),
            Space(
                name: "Cabinet Boardroom",
                kind: .boardroom,
                rect: CGRect(x: 0.77, y: 0.55, width: 0.18, height: 0.25),
                capacity: 16,
                events: [
                    Event(
                        title: "Executive Board Meeting",
                        category: .meeting,
                        start: today(9), end: today(11),
                        host: "Comstock Holdings",
                        attendeeCount: 12
                    )
                ]
            )
        ]
    )

    // MARK: - Lobby Level

    private static let lobbyLevel = Floor(
        level: 1,
        name: "Lobby Level",
        spaces: [
            // L-shaped lobby wrapping the entrance and elevator core.
            Space(
                name: "Hotel Lobby",
                kind: .lobby,
                polygon: [
                    CGPoint(x: 0.05, y: 0.05),
                    CGPoint(x: 0.45, y: 0.05),
                    CGPoint(x: 0.45, y: 0.22),
                    CGPoint(x: 0.26, y: 0.22),
                    CGPoint(x: 0.26, y: 0.42),
                    CGPoint(x: 0.05, y: 0.42)
                ],
                capacity: 0
            ),
            Space(
                name: "Lobby Restaurant",
                kind: .restaurant,
                rect: CGRect(x: 0.50, y: 0.05, width: 0.45, height: 0.34),
                capacity: 140,
                events: [
                    Event(
                        title: "Breakfast Service",
                        category: .banquet,
                        start: today(6, 30), end: today(10, 30),
                        host: "Culinary Team",
                        attendeeCount: 120,
                        notes: "À la carte and buffet breakfast."
                    )
                ]
            ),
            Space(
                name: "Lobby Bar & Lounge",
                kind: .lounge,
                rect: CGRect(x: 0.05, y: 0.50, width: 0.40, height: 0.28),
                capacity: 90,
                events: [
                    Event(
                        title: "Summit Welcome Reception",
                        category: .social,
                        start: today(18), end: today(20),
                        host: "NoVA Tech Council",
                        attendeeCount: 130,
                        notes: "Cocktails and passed hors d'oeuvres."
                    )
                ]
            ),
            Space(
                name: "Fitness Center",
                kind: .fitness,
                rect: CGRect(x: 0.50, y: 0.50, width: 0.20, height: 0.28),
                capacity: 30,
                events: [
                    Event(
                        title: "Sunrise Yoga",
                        category: .fitness,
                        start: today(6, 30), end: today(7, 30),
                        host: "Wellness Studio",
                        attendeeCount: 18
                    )
                ]
            ),
            Space(
                name: "Spa & Wellness",
                kind: .fitness,
                rect: CGRect(x: 0.72, y: 0.50, width: 0.23, height: 0.28),
                capacity: 20
            )
        ]
    )
}
