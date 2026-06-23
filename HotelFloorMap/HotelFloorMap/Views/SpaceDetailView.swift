import SwiftUI

/// Presented when a space on the floor plan is tapped. Lists the events
/// scheduled in that space, grouped by time. Display-only.
struct SpaceDetailView: View {
    let space: Space
    let now: Date

    @Environment(\.dismiss) private var dismiss

    private var live: [Event] { space.liveEvents(at: now) }
    private var upcoming: [Event] { space.upcomingEvents(at: now) }
    private var past: [Event] { space.events.filter { $0.end < now } }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    SpaceHeader(space: space)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }

                if !space.kind.isBookable {
                    ContentUnavailableView(
                        "No Scheduled Events",
                        systemImage: space.kind.symbolName,
                        description: Text("\(space.name) isn't used for scheduled events.")
                    )
                    .listRowBackground(Color.clear)
                } else if space.events.isEmpty {
                    ContentUnavailableView(
                        "No Events Scheduled",
                        systemImage: "calendar",
                        description: Text("This space is available all day.")
                    )
                    .listRowBackground(Color.clear)
                } else {
                    eventSection("Happening Now", events: live, accent: .red)
                    eventSection("Later Today", events: upcoming, accent: .blue)
                    eventSection("Earlier Today", events: past, accent: .secondary)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(space.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Event.self) { event in
                EventDetailView(event: event, spaceName: space.name, now: now)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    @ViewBuilder
    private func eventSection(_ title: String, events: [Event], accent: Color) -> some View {
        if !events.isEmpty {
            Section {
                ForEach(events) { event in
                    NavigationLink(value: event) {
                        EventRow(event: event, now: now)
                    }
                }
            } header: {
                Label(title, systemImage: title == "Happening Now" ? "dot.radiowaves.left.and.right" : "clock")
                    .foregroundStyle(accent)
            }
        }
    }
}

private struct SpaceHeader: View {
    let space: Space

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: space.kind.symbolName)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(Color.accentColor.gradient, in: .rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {
                Text(space.kind.rawValue)
                    .font(.headline)
                if space.capacity > 0 {
                    Label("Capacity \(space.capacity)", systemImage: "person.2.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SpaceDetailView(space: SampleData.venue.floors[0].spaces[0], now: .now)
}
