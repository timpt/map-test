import SwiftUI

/// Full detail for a single event.
struct EventDetailView: View {
    let event: Event
    let spaceName: String
    let now: Date

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label(event.category.rawValue, systemImage: event.category.symbolName)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(event.category.tint.gradient))
                        Spacer()
                        if event.isLive(at: now) {
                            Label("Live now", systemImage: "dot.radiowaves.left.and.right")
                                .font(.caption.bold())
                                .foregroundStyle(.red)
                        }
                    }
                    Text(event.title)
                        .font(.title2.bold())
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }

            Section("Details") {
                detailRow(icon: "clock", title: "Time", value: event.timeRangeText)
                detailRow(icon: "hourglass", title: "Duration", value: event.durationText)
                detailRow(icon: "mappin.and.ellipse", title: "Location", value: spaceName)
                detailRow(icon: "person.2.fill", title: "Attendees", value: "\(event.attendeeCount)")
                detailRow(icon: "person.crop.circle", title: "Host", value: event.host)
            }

            if !event.notes.isEmpty {
                Section("Notes") {
                    Text(event.notes)
                        .font(.callout)
                }
            }
        }
        .navigationTitle("Event")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}

#Preview {
    NavigationStack {
        EventDetailView(
            event: SampleData.venue.floors[0].spaces[3].events[0],
            spaceName: "Pacific Ballroom",
            now: .now
        )
    }
}
