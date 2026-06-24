import SwiftUI

/// A scheduled event that takes place inside a particular `Space`.
struct Event: Identifiable, Hashable {
    let id: UUID
    var title: String
    var category: EventCategory
    var start: Date
    var end: Date
    var host: String
    var attendeeCount: Int
    var notes: String

    init(
        id: UUID = UUID(),
        title: String,
        category: EventCategory,
        start: Date,
        end: Date,
        host: String,
        attendeeCount: Int,
        notes: String = ""
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.start = start
        self.end = end
        self.host = host
        self.attendeeCount = attendeeCount
        self.notes = notes
    }

    /// `true` when the event is currently underway relative to `reference`.
    func isLive(at reference: Date = .now) -> Bool {
        (start...end).contains(reference)
    }

    /// `true` when the event has not started yet.
    func isUpcoming(at reference: Date = .now) -> Bool {
        start > reference
    }

    var timeRangeText: String {
        let time = Date.FormatStyle.dateTime.hour().minute()
        let weekday = start.formatted(.dateTime.weekday(.abbreviated))
        return "\(weekday) \(start.formatted(time)) – \(end.formatted(time))"
    }

    var durationText: String {
        let minutes = Int(end.timeIntervalSince(start) / 60)
        if minutes < 60 { return "\(minutes) min" }
        let hours = Double(minutes) / 60
        return hours == hours.rounded() ? "\(Int(hours)) hr" : String(format: "%.1f hr", hours)
    }
}
