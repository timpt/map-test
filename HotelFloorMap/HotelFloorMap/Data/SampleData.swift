import SwiftUI

/// Demo content for the **JW Marriott Reston Station** (Reston, VA), Third Level
/// event space. The floor plan is the venue's real drawing (rendered from
/// `floorplan` in the asset catalog); each `Space.polygon` is traced onto that
/// drawing in its normalized (0...1) coordinate space. Events are illustrative
/// and anchored to *today* so "live" highlighting reflects the current time.
enum SampleData {

    static let venue = Venue(
        name: "JW Marriott Reston Station",
        subtitle: "Third Level · Event Space",
        floors: [thirdLevel]
    )

    /// A `Date` today at the given hour/minute in the user's calendar.
    private static func today(_ hour: Int, _ minute: Int = 0) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: .now) ?? .now
    }

    private static let thirdLevel = Floor(
        level: 3,
        name: "Third Level",
        imageName: "floorplan",
        spaces: [
            Space(
                name: "Jewel Box",
                kind: .ballroom,
                polygon: [CGPoint(x: 0.2332, y: 0.1668), CGPoint(x: 0.4056, y: 0.1855), CGPoint(x: 0.4187, y: 0.3214), CGPoint(x: 0.2451, y: 0.3255)],
                capacity: 250,
                events: [
                    Event(
                        title: "Ramirez–Cole Wedding",
                        category: .wedding,
                        start: today(17), end: today(23),
                        host: "Events by Lumen",
                        attendeeCount: 180,
                        notes: "Ceremony at 5:00 PM, reception to follow."
                    )
                ]
            ),
            Space(
                name: "Luminary Ballroom",
                kind: .ballroom,
                polygon: [CGPoint(x: 0.2809, y: 0.3417), CGPoint(x: 0.4241, y: 0.332), CGPoint(x: 0.4295, y: 0.4679), CGPoint(x: 0.2907, y: 0.4866)],
                capacity: 600,
                events: [
                    Event(
                        title: "Northern Virginia Tech Summit",
                        category: .conference,
                        start: today(9), end: today(12),
                        host: "NoVA Tech Council",
                        attendeeCount: 540,
                        notes: "Opening keynote and morning general sessions."
                    ),
                    Event(
                        title: "Innovation Awards Gala",
                        category: .banquet,
                        start: today(19), end: today(22, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 480
                    )
                ]
            ),
            Space(
                name: "JW Ballroom Salon 1",
                kind: .ballroom,
                polygon: [CGPoint(x: 0.2793, y: 0.4898), CGPoint(x: 0.4056, y: 0.4947), CGPoint(x: 0.4067, y: 0.5842), CGPoint(x: 0.2809, y: 0.5793)],
                capacity: 200,
                events: [
                    Event(
                        title: "Cloud Infrastructure Track",
                        category: .conference,
                        start: today(13), end: today(15, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 160
                    )
                ]
            ),
            Space(
                name: "JW Ballroom Salon 2",
                kind: .ballroom,
                polygon: [CGPoint(x: 0.3449, y: 0.5826), CGPoint(x: 0.4067, y: 0.5842), CGPoint(x: 0.4089, y: 0.6819), CGPoint(x: 0.3471, y: 0.6794)],
                capacity: 150,
                events: [
                    Event(
                        title: "Security & Identity Workshop",
                        category: .workshop,
                        start: today(10), end: today(13),
                        host: "API Platform Team",
                        attendeeCount: 90,
                        notes: "Hands-on lab — bring a laptop."
                    )
                ]
            ),
            Space(
                name: "JW Ballroom Salon 3",
                kind: .ballroom,
                polygon: [CGPoint(x: 0.2809, y: 0.5793), CGPoint(x: 0.3449, y: 0.5826), CGPoint(x: 0.3482, y: 0.7771), CGPoint(x: 0.2847, y: 0.7746)],
                capacity: 150,
                events: [
                    Event(
                        title: "Partner Networking Lunch",
                        category: .social,
                        start: today(12), end: today(13, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 140
                    )
                ]
            ),
            Space(
                name: "JW Ballroom Salon 4",
                kind: .ballroom,
                polygon: [CGPoint(x: 0.3471, y: 0.6794), CGPoint(x: 0.4089, y: 0.6819), CGPoint(x: 0.4111, y: 0.7795), CGPoint(x: 0.3482, y: 0.7771)],
                capacity: 150
            ),
            Space(
                name: "Black Canvas",
                kind: .meetingRoom,
                polygon: [CGPoint(x: 0.5477, y: 0.7583), CGPoint(x: 0.6063, y: 0.7616), CGPoint(x: 0.6052, y: 0.8771), CGPoint(x: 0.5466, y: 0.8747)],
                capacity: 80,
                events: [
                    Event(
                        title: "Product Design Workshop",
                        category: .workshop,
                        start: today(10), end: today(13),
                        host: "Studio North",
                        attendeeCount: 45
                    )
                ]
            ),
            Space(
                name: "Meeting Room 1",
                kind: .meetingRoom,
                polygon: [CGPoint(x: 0.6063, y: 0.7616), CGPoint(x: 0.6464, y: 0.764), CGPoint(x: 0.6453, y: 0.8788), CGPoint(x: 0.6052, y: 0.8771)],
                capacity: 40,
                events: [
                    Event(
                        title: "Investor Roundtable",
                        category: .meeting,
                        start: today(11), end: today(12, 30),
                        host: "Meridian Ventures",
                        attendeeCount: 22
                    )
                ]
            ),
            Space(
                name: "Meeting Room 2",
                kind: .meetingRoom,
                polygon: [CGPoint(x: 0.6464, y: 0.764), CGPoint(x: 0.6887, y: 0.7673), CGPoint(x: 0.6876, y: 0.8804), CGPoint(x: 0.6453, y: 0.8788)],
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
                name: "Meeting Room 3",
                kind: .meetingRoom,
                polygon: [CGPoint(x: 0.6887, y: 0.7673), CGPoint(x: 0.7332, y: 0.7705), CGPoint(x: 0.7321, y: 0.8836), CGPoint(x: 0.6876, y: 0.8804)],
                capacity: 40
            ),
            Space(
                name: "Meeting Room 4",
                kind: .meetingRoom,
                polygon: [CGPoint(x: 0.7332, y: 0.7705), CGPoint(x: 0.7983, y: 0.7754), CGPoint(x: 0.7972, y: 0.8869), CGPoint(x: 0.7321, y: 0.8836)],
                capacity: 40,
                events: [
                    Event(
                        title: "Recruiting Interviews",
                        category: .meeting,
                        start: today(9), end: today(17),
                        host: "People Team",
                        attendeeCount: 8,
                        notes: "Back-to-back 45-minute slots throughout the day."
                    )
                ]
            ),
            Space(
                name: "Board Room",
                kind: .boardroom,
                polygon: [CGPoint(x: 0.7495, y: 0.891), CGPoint(x: 0.8091, y: 0.8942), CGPoint(x: 0.8091, y: 0.9642), CGPoint(x: 0.7495, y: 0.9626)],
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
            ),
            Space(
                name: "The Counter",
                kind: .lounge,
                polygon: [CGPoint(x: 0.4989, y: 0.7933), CGPoint(x: 0.5249, y: 0.795), CGPoint(x: 0.5249, y: 0.8511), CGPoint(x: 0.4989, y: 0.8495)],
                capacity: 60,
                events: [
                    Event(
                        title: "Registration & Coffee",
                        category: .social,
                        start: today(8), end: today(9),
                        host: "NoVA Tech Council",
                        attendeeCount: 300
                    )
                ]
            )
        ]
    )
}
