import SwiftUI

/// A form for booking a new event into a space.
struct AddEventView: View {
    let store: VenueStore
    let space: Space

    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var category: EventCategory = .meeting
    @State private var start: Date
    @State private var end: Date
    @State private var host: String = ""
    @State private var attendeeCount: Int
    @State private var notes: String = ""

    init(store: VenueStore, space: Space) {
        self.store = store
        self.space = space
        let startDefault = Self.nextHour()
        _start = State(initialValue: startDefault)
        _end = State(initialValue: startDefault.addingTimeInterval(3600))
        _attendeeCount = State(initialValue: space.capacity > 0 ? min(20, space.capacity) : 20)
    }

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && end > start
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Event title", text: $title)
                    Picker("Category", selection: $category) {
                        ForEach(EventCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.symbolName).tag(cat)
                        }
                    }
                }

                Section("Schedule") {
                    DatePicker("Starts", selection: $start)
                        .onChange(of: start) { _, newValue in
                            if end <= newValue { end = newValue.addingTimeInterval(3600) }
                        }
                    DatePicker("Ends", selection: $end, in: start...)
                }

                Section("Details") {
                    TextField("Host / organizer", text: $host)
                    Stepper(value: $attendeeCount, in: 1...(space.capacity > 0 ? space.capacity : 1000)) {
                        LabeledContent("Attendees", value: "\(attendeeCount)")
                    }
                    if space.capacity > 0 {
                        LabeledContent("Room capacity", value: "\(space.capacity)")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Notes") {
                    TextField("Optional notes", text: $notes, axis: .vertical)
                        .lineLimit(2...5)
                }
            }
            .navigationTitle("Book \(space.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { save() }
                        .disabled(!isValid)
                }
            }
        }
    }

    private func save() {
        let event = Event(
            title: title.trimmingCharacters(in: .whitespaces),
            category: category,
            start: start,
            end: end,
            host: host.trimmingCharacters(in: .whitespaces).isEmpty
                ? "Unassigned" : host.trimmingCharacters(in: .whitespaces),
            attendeeCount: attendeeCount,
            notes: notes.trimmingCharacters(in: .whitespaces)
        )
        store.addEvent(event, toSpaceID: space.id)
        dismiss()
    }

    /// The next top-of-the-hour from now.
    private static func nextHour() -> Date {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month, .day, .hour], from: .now)
        let thisHour = calendar.date(from: comps) ?? .now
        return calendar.date(byAdding: .hour, value: 1, to: thisHour) ?? .now
    }
}

#Preview {
    AddEventView(store: VenueStore(venue: SampleData.venue), space: SampleData.venue.floors[0].spaces[1])
}
