import SwiftUI

/// Shows a hotel's interactive floor plan with a floor selector. Each space is
/// tappable; tapping one presents the events assigned to that space.
struct FloorMapView: View {
    let hotel: Hotel

    @State private var selectedFloorID: Floor.ID
    @State private var selectedSpace: Space?
    /// Drives a periodic refresh so "live" highlighting stays current.
    @State private var now: Date = .now

    private let ticker = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    init(hotel: Hotel) {
        self.hotel = hotel
        _selectedFloorID = State(initialValue: hotel.floors.first?.id ?? UUID())
    }

    private var selectedFloor: Floor {
        hotel.floors.first { $0.id == selectedFloorID } ?? hotel.floors[0]
    }

    var body: some View {
        VStack(spacing: 0) {
            FloorPlanView(
                floor: selectedFloor,
                now: now,
                onSelect: { selectedSpace = $0 }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))

            LegendBar()
        }
        .navigationTitle(hotel.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FloorPicker(floors: hotel.floors, selection: $selectedFloorID, now: now)
            }
        }
        .sheet(item: $selectedSpace) { space in
            SpaceDetailView(space: space, now: now)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .onReceive(ticker) { now = $0 }
    }
}

/// A segmented-style picker for choosing the visible floor.
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
    NavigationStack {
        FloorMapView(hotel: SampleData.grandHarbor)
    }
}
