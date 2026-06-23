import SwiftUI

/// The app's root screen: an interactive floor plan for a single venue. Pick a
/// floor from the toolbar; pinch to zoom and drag to pan; tap any room/area to
/// see (and book) the events assigned to it.
struct VenueFloorPlanView: View {
    @State private var store: VenueStore
    @State private var selectedFloorID: Floor.ID
    @State private var selectedSpace: Space?
    /// Drives a periodic refresh so "live" highlighting stays current.
    @State private var now: Date = .now

    private let ticker = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    init(venue: Venue) {
        _store = State(initialValue: VenueStore(venue: venue))
        _selectedFloorID = State(initialValue: venue.floors.first?.id ?? UUID())
    }

    private var venue: Venue { store.venue }

    private var selectedFloor: Floor {
        venue.floors.first { $0.id == selectedFloorID } ?? venue.floors[0]
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                FloorSummaryBar(floor: selectedFloor, now: now)

                ZoomPanView {
                    FloorPlanView(
                        floor: selectedFloor,
                        now: now,
                        onSelect: { selectedSpace = $0 }
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))

                LegendBar()
            }
            .navigationTitle(venue.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    FloorPicker(floors: venue.floors, selection: $selectedFloorID, now: now)
                }
            }
            .sheet(item: $selectedSpace) { space in
                SpaceDetailView(store: store, spaceID: space.id, now: now)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .onReceive(ticker) { now = $0 }
        }
    }
}

/// A strip under the navigation bar describing the visible floor at a glance.
private struct FloorSummaryBar: View {
    let floor: Floor
    let now: Date

    private var liveCount: Int { floor.liveEventCount(at: now) }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(floor.name)
                    .font(.headline)
                Text("\(floor.eventCount) events today")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if liveCount > 0 {
                Label("\(liveCount) live now", systemImage: "dot.radiowaves.left.and.right")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(.red))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.bar)
    }
}

/// A menu for choosing the visible floor.
private struct FloorPicker: View {
    let floors: [Floor]
    @Binding var selection: Floor.ID
    let now: Date

    var body: some View {
        Menu {
            ForEach(floors) { floor in
                Button {
                    selection = floor.id
                } label: {
                    let live = floor.liveEventCount(at: now)
                    Label(
                        live > 0 ? "\(floor.name) · \(live) live" : floor.name,
                        systemImage: floor.id == selection ? "checkmark" : "square.stack.3d.up"
                    )
                }
            }
        } label: {
            Label("Floor \(currentFloor.shortName)", systemImage: "square.stack.3d.up.fill")
        }
    }

    private var currentFloor: Floor {
        floors.first { $0.id == selection } ?? floors[0]
    }
}

/// Color key explaining what the space tints mean.
private struct LegendBar: View {
    var body: some View {
        HStack(spacing: 18) {
            legendItem(color: .red, label: "Live now")
            legendItem(color: .blue, label: "Scheduled")
            legendItem(color: .secondary, label: "Available")
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.bar)
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 5) {
            Circle().fill(color).frame(width: 9, height: 9)
            Text(label)
        }
    }
}

#Preview {
    VenueFloorPlanView(venue: SampleData.venue)
}
