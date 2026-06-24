import SwiftUI

/// Demo content for the **JW Marriott Reston Station** (Reston, VA), Third Level
/// event space, modeled as a **3-day conference** so the time scrubber has
/// something to browse. The room fills are drawn under the venue's real walls +
/// labels (`floorplanWalls`); each `Space.polygon` is traced onto that drawing
/// in its normalized (0...1) coordinate space. Day 1 is *today*, so the map's
/// default "now" view reflects sessions actually underway.
enum SampleData {

    static let venue = Venue(
        name: "JW Marriott Reston Station",
        subtitle: "Third Level · Event Space",
        floors: [thirdLevel]
    )

    /// A `Date` on conference `day` (0 = today, 1 = tomorrow, …) at the given
    /// hour/minute in the user's calendar.
    private static func at(_ day: Int, _ hour: Int, _ minute: Int = 0) -> Date {
        let calendar = Calendar.current
        let base = calendar.date(byAdding: .day, value: day, to: calendar.startOfDay(for: .now)) ?? .now
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: base) ?? base
    }

    private static let thirdLevel = Floor(
        level: 3,
        name: "Third Level",
        imageName: "floorplanWalls",
        spaces: [
            Space(
                name: "Jewel Box",
                kind: .ballroom,
                polygon: [CGPoint(x: 0.2415, y: 0.3246), CGPoint(x: 0.2915, y: 0.3178), CGPoint(x: 0.2879, y: 0.2783), CGPoint(x: 0.3224, y: 0.2742), CGPoint(x: 0.3197, y: 0.2442), CGPoint(x: 0.3879, y: 0.2332), CGPoint(x: 0.3906, y: 0.2633), CGPoint(x: 0.3752, y: 0.2673), CGPoint(x: 0.377, y: 0.2905), CGPoint(x: 0.4124, y: 0.2824), CGPoint(x: 0.4052, y: 0.1582), CGPoint(x: 0.2333, y: 0.1814)],
                capacity: 250,
                events: [
                    Event(
                        title: "Welcome Reception",
                        category: .social,
                        start: at(0, 17), end: at(0, 19),
                        host: "NoVA Tech Council",
                        attendeeCount: 220,
                        notes: "Drinks and light bites to kick off the summit."
                    ),
                    Event(
                        title: "Design Systems Summit",
                        category: .conference,
                        start: at(1, 10), end: at(1, 13),
                        host: "Studio North",
                        attendeeCount: 180
                    ),
                    Event(
                        title: "Ramirez–Cole Wedding",
                        category: .wedding,
                        start: at(2, 17), end: at(2, 23),
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
                        title: "Opening Keynote",
                        category: .conference,
                        start: at(0, 9), end: at(0, 10, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 560,
                        notes: "State of the platform and the year ahead."
                    ),
                    Event(
                        title: "Platform Vision Session",
                        category: .conference,
                        start: at(0, 11), end: at(0, 12, 15),
                        host: "NoVA Tech Council",
                        attendeeCount: 540
                    ),
                    Event(
                        title: "Innovation Awards Gala",
                        category: .banquet,
                        start: at(0, 19), end: at(0, 22, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 480
                    ),
                    Event(
                        title: "Day 2 Keynote",
                        category: .conference,
                        start: at(1, 9), end: at(1, 10, 15),
                        host: "NoVA Tech Council",
                        attendeeCount: 530
                    ),
                    Event(
                        title: "Lightning Talks",
                        category: .conference,
                        start: at(1, 11), end: at(1, 12, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 410
                    ),
                    Event(
                        title: "Closing Keynote",
                        category: .conference,
                        start: at(2, 9), end: at(2, 10, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 500
                    ),
                    Event(
                        title: "Career & Hiring Fair",
                        category: .social,
                        start: at(2, 13), end: at(2, 16, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 300
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
                        start: at(0, 13), end: at(0, 15, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 160
                    ),
                    Event(
                        title: "AI & Machine Learning Track",
                        category: .conference,
                        start: at(1, 9), end: at(1, 12),
                        host: "NoVA Tech Council",
                        attendeeCount: 190
                    ),
                    Event(
                        title: "Open Source Roundtable",
                        category: .meeting,
                        start: at(2, 10), end: at(2, 11, 30),
                        host: "CNCF Reston",
                        attendeeCount: 70
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
                        start: at(0, 10), end: at(0, 13),
                        host: "API Platform Team",
                        attendeeCount: 90,
                        notes: "Hands-on lab — bring a laptop."
                    ),
                    Event(
                        title: "Data Engineering Track",
                        category: .conference,
                        start: at(1, 13), end: at(1, 16),
                        host: "NoVA Tech Council",
                        attendeeCount: 130
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
                        start: at(0, 12), end: at(0, 13, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 140
                    ),
                    Event(
                        title: "Women in Tech Breakfast",
                        category: .social,
                        start: at(1, 8), end: at(1, 9),
                        host: "Women Who Code",
                        attendeeCount: 95
                    ),
                    Event(
                        title: "Developer Q&A",
                        category: .meeting,
                        start: at(1, 14), end: at(1, 15, 30),
                        host: "Developer Relations",
                        attendeeCount: 110
                    ),
                    Event(
                        title: "Farewell Lunch",
                        category: .social,
                        start: at(2, 12), end: at(2, 13, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 150
                    )
                ]
            ),
            Space(
                name: "JW Ballroom Salon 4",
                kind: .ballroom,
                polygon: [CGPoint(x: 0.36, y: 0.7622), CGPoint(x: 0.4091, y: 0.7513), CGPoint(x: 0.4009, y: 0.6572), CGPoint(x: 0.3518, y: 0.664)],
                capacity: 150,
                events: [
                    Event(
                        title: "DevOps Hands-on Workshop",
                        category: .workshop,
                        start: at(1, 10), end: at(1, 13),
                        host: "Platform Engineering",
                        attendeeCount: 120,
                        notes: "Bring a laptop with Docker installed."
                    ),
                    Event(
                        title: "Hackathon Showcase",
                        category: .workshop,
                        start: at(2, 10), end: at(2, 12),
                        host: "NoVA Tech Council",
                        attendeeCount: 130
                    )
                ]
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
                        start: at(0, 10), end: at(0, 13),
                        host: "Studio North",
                        attendeeCount: 45
                    ),
                    Event(
                        title: "UX Research Clinic",
                        category: .workshop,
                        start: at(1, 14), end: at(1, 16),
                        host: "Studio North",
                        attendeeCount: 40
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
                        start: at(0, 11), end: at(0, 12, 30),
                        host: "Meridian Ventures",
                        attendeeCount: 22
                    ),
                    Event(
                        title: "1:1 Mentor Sessions",
                        category: .meeting,
                        start: at(1, 13), end: at(1, 16),
                        host: "Developer Relations",
                        attendeeCount: 18,
                        notes: "Sign up at the registration desk."
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
                        start: at(0, 14), end: at(0, 15),
                        host: "NoVA Tech Council",
                        attendeeCount: 30
                    ),
                    Event(
                        title: "Analyst Briefing",
                        category: .meeting,
                        start: at(2, 11), end: at(2, 12),
                        host: "NoVA Tech Council",
                        attendeeCount: 25
                    )
                ]
            ),
            Space(
                name: "Meeting Room 3",
                kind: .meetingRoom,
                polygon: [CGPoint(x: 0.6927, y: 0.8386), CGPoint(x: 0.7418, y: 0.8386), CGPoint(x: 0.7427, y: 0.7813), CGPoint(x: 0.7045, y: 0.7813), CGPoint(x: 0.7045, y: 0.7731), CGPoint(x: 0.6936, y: 0.769)],
                capacity: 40,
                events: [
                    Event(
                        title: "Community Organizers Sync",
                        category: .meeting,
                        start: at(1, 10), end: at(1, 11),
                        host: "NoVA Tech Council",
                        attendeeCount: 16
                    )
                ]
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
                        start: at(0, 9), end: at(0, 17),
                        host: "People Team",
                        attendeeCount: 8,
                        notes: "Back-to-back 45-minute slots throughout the day."
                    ),
                    Event(
                        title: "Recruiting Interviews",
                        category: .meeting,
                        start: at(1, 9), end: at(1, 17),
                        host: "People Team",
                        attendeeCount: 8
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
                        start: at(0, 9), end: at(0, 11),
                        host: "Comstock Holdings",
                        attendeeCount: 12
                    ),
                    Event(
                        title: "Sponsor Advisory Council",
                        category: .meeting,
                        start: at(1, 15), end: at(1, 16, 30),
                        host: "NoVA Tech Council",
                        attendeeCount: 14
                    )
                ]
            )
        ]
    )
}
