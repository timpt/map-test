import SwiftUI

/// Demo content for the **JW Marriott Reston Station** (Reston, VA), Third Level
/// event space. Rooms are drawn on top of the venue's real building footprint
/// (`floorplanFootprint` in the asset catalog); each `Space.polygon` is traced
/// in that image's normalized (0...1) coordinate space. Events are illustrative
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
        imageName: "floorplanFootprint",
        spaces: [
            Space(
                name: "Jewel Box",
                kind: .ballroom,
                polygon: [CGPoint(x: 0.2415, y: 0.3246), CGPoint(x: 0.2915, y: 0.3178), CGPoint(x: 0.2879, y: 0.2783), CGPoint(x: 0.3224, y: 0.2742), CGPoint(x: 0.3197, y: 0.2442), CGPoint(x: 0.3879, y: 0.2332), CGPoint(x: 0.3906, y: 0.2633), CGPoint(x: 0.3752, y: 0.2673), CGPoint(x: 0.377, y: 0.2905), CGPoint(x: 0.4124, y: 0.2824), CGPoint(x: 0.4052, y: 0.1582), CGPoint(x: 0.2333, y: 0.1814)],
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
                polygon: [CGPoint(x: 0.2806, y: 0.3355), CGPoint(x: 0.4179, y: 0.3124), CGPoint(x: 0.4288, y: 0.461), CGPoint(x: 0.2915, y: 0.4842)],
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
                polygon: [CGPoint(x: 0.2815, y: 0.4842), CGPoint(x: 0.2897, y: 0.5852), CGPoint(x: 0.3933, y: 0.5674), CGPoint(x: 0.3852, y: 0.4679)],
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
                polygon: [CGPoint(x: 0.29, y: 0.5863), CGPoint(x: 0.3927, y: 0.5685), CGPoint(x: 0.4009, y: 0.6545), CGPoint(x: 0.2955, y: 0.6722)],
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
                polygon: [CGPoint(x: 0.3036, y: 0.7704), CGPoint(x: 0.2955, y: 0.6735), CGPoint(x: 0.3509, y: 0.664), CGPoint(x: 0.3591, y: 0.7622)],
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
                polygon: [CGPoint(x: 0.36, y: 0.7622), CGPoint(x: 0.4091, y: 0.7513), CGPoint(x: 0.4009, y: 0.6572), CGPoint(x: 0.3518, y: 0.664)],
                capacity: 150
            ),
            Space(
                name: "Black Canvas",
                kind: .meetingRoom,
                polygon: [CGPoint(x: 0.5445, y: 0.8386), CGPoint(x: 0.5436, y: 0.7308), CGPoint(x: 0.5982, y: 0.7445), CGPoint(x: 0.5982, y: 0.8386)],
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
                polygon: [CGPoint(x: 0.5982, y: 0.7445), CGPoint(x: 0.6427, y: 0.7581), CGPoint(x: 0.6436, y: 0.84), CGPoint(x: 0.5982, y: 0.84)],
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
                polygon: [CGPoint(x: 0.6436, y: 0.8386), CGPoint(x: 0.6927, y: 0.84), CGPoint(x: 0.6927, y: 0.7704), CGPoint(x: 0.6436, y: 0.7568)],
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
                polygon: [CGPoint(x: 0.6927, y: 0.8386), CGPoint(x: 0.7418, y: 0.8386), CGPoint(x: 0.7427, y: 0.7813), CGPoint(x: 0.7045, y: 0.7813), CGPoint(x: 0.7045, y: 0.7731), CGPoint(x: 0.6936, y: 0.769)],
                capacity: 40
            ),
            Space(
                name: "Meeting Room 4",
                kind: .meetingRoom,
                polygon: [CGPoint(x: 0.7427, y: 0.8386), CGPoint(x: 0.76, y: 0.8386), CGPoint(x: 0.76, y: 0.8522), CGPoint(x: 0.7882, y: 0.8509), CGPoint(x: 0.7873, y: 0.7909), CGPoint(x: 0.7427, y: 0.7895)],
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
                polygon: [CGPoint(x: 0.7418, y: 0.9041), CGPoint(x: 0.7418, y: 0.9586), CGPoint(x: 0.7882, y: 0.9586), CGPoint(x: 0.7882, y: 0.9027)],
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
}
