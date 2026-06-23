import SwiftUI

/// Presented when a space on the floor plan is tapped. Lists the events assigned
/// to that space (read live from the store) and lets you book a new one.
struct SpaceDetailView: View {
    let store: VenueStore
    let spaceID: Space.ID
    let now: Date

    @Environment(\.dismiss) private var dismiss
    @State private var showingAddEvent = false

    private var space: Space? { store.space(id: spaceID) }

    var body: some View {
        NavigationStack {
            if let space {
                content(for: space)
                    .navigationTitle(space.name)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationDestination(for: Event.self) { event in
                        EventDetailView(event: event, spaceName: space.name, now: now)
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Done") { dismiss() }
                        }
                        if space.kind.isBookable {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    showingAddEvent = true
                                } label: {
                                    Label("Book", systemImage: "plus")
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $showingAddEvent) {
                        AddEventView(store: store, space: space)
                    }
            } else {
                Color.clear.onAppear { dismiss() }
            }
        }
    }

    @ViewBuilder
    private func content(for space: Space) -> some View {
        let live = space.liveEvents(at: now)
        let upcoming = space.upcomingEvents(at: now)
        let past = space.events.filter { $0.end < now }

        List {
            Section {
                SpaceHeader(space: space)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }

            if !space.kind.isBookable {
                ContentUnavailableView(
                    "Not a Bookable Space",
                    systemImage: space.kind.symbolName,
                    description: Text("\(space.name) isn't used for scheduled events.")
                )
                .listRowBackground(Color.clear)
            } else if space.events.isEmpty {
                Section {
                    ContentUnavailableView {
                        Label("No Events Scheduled", systemImage: "calendar.badge.plus")
                    } description: {
                        Text("This space is available all day.")
                    } actions: {
                        Button {
                            showingAddEvent = true
                        } label: {
                            Label("Book This Space", systemImage: "plus")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .listRowBackground(Color.clear)
                }
            } else {
                eventSection("Happening Now", events: live, accent: .red)
                eventSection("Later Today", events: upcoming, accent: .blue)
                eventSection("Earlier Today", events: past, accent: .secondary)
            }
        }
        .listStyle(.insetGrouped)
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
    SpaceDetailView(
        store: VenueStore(venue: SampleData.venue),
        spaceID: SampleData.venue.floors[0].spaces[1].id,
        now: .now
    )
}
