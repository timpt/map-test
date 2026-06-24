import SwiftUI

/// The app's root screen: an interactive floor plan for a single venue. Pick a
/// floor from the toolbar; pinch to zoom and drag to pan; tap any room/area to
/// see the events scheduled in it.
struct VenueFloorPlanView: View {
    let venue: Venue

    @State private var selectedFloorID: Floor.ID
    @State private var selectedSpace: Space?
    /// The real current time, advanced by the ticker.
    @State private var now: Date = .now
    /// The moment the map reflects — set by the scrubber, defaults to `now`.
    @State private var viewingDate: Date = .now
    /// Whether the map is following the live clock (vs a scrubbed time).
    @State private var pinnedToNow = true
    /// Whether the settings sheet is showing.
    @State private var showingSettings = false
    /// User preference: gently pulse rooms that are live right now.
    @AppStorage(SettingsKey.livePulse) private var livePulseEnabled = true

    private let ticker = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    init(venue: Venue) {
        self.venue = venue
        _selectedFloorID = State(initialValue: venue.floors.first?.id ?? UUID())
    }

    private var selectedFloor: Floor {
        venue.floors.first { $0.id == selectedFloorID } ?? venue.floors[0]
    }

    /// Hour-of-day bounds for the slider, derived from the day's events with a
    /// little padding; falls back to a sensible daytime window.
    private var hourRange: ClosedRange<Double> {
        guard let span = selectedFloor.eventTimeSpan else { return 8...22 }
        let cal = Calendar.current
        let lower = max(0, Double(cal.component(.hour, from: span.lowerBound)) - 1)
        let upperHour = Double(cal.component(.hour, from: span.upperBound))
        let upperMin = Double(cal.component(.minute, from: span.upperBound))
        let upper = min(24, (upperMin > 0 ? upperHour + 1 : upperHour) + 1)
        return lower...max(lower + 1, upper)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                FloorSummaryBar(floor: selectedFloor, viewingDate: viewingDate, pinnedToNow: pinnedToNow)

                ZoomPanView {
                    FloorPlanView(
                        floor: selectedFloor,
                        now: viewingDate,
                        selectedSpaceID: selectedSpace?.id,
                        emphasizeLive: pinnedToNow && livePulseEnabled,
                        onSelect: { selectedSpace = $0 }
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.949, green: 0.941, blue: 0.918))

                TimeScrubber(
                    days: selectedFloor.eventDays,
                    hourRange: hourRange,
                    selectedDate: $viewingDate,
                    isPinnedToNow: pinnedToNow,
                    onScrub: { pinnedToNow = false },
                    onJumpToNow: {
                        pinnedToNow = true
                        viewingDate = now
                    }
                )

                LegendBar()
            }
            .navigationTitle(venue.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if venue.floors.count > 1 {
                    ToolbarItem(placement: .topBarTrailing) {
                        FloorPicker(floors: venue.floors, selection: $selectedFloorID, now: viewingDate)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .sheet(item: $selectedSpace) { space in
                SpaceDetailView(space: space, now: viewingDate)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .presentationDetents([.medium])
            }
            .onReceive(ticker) { newNow in
                now = newNow
                if pinnedToNow { viewingDate = newNow }
            }
        }
    }
}

/// A strip under the navigation bar summarizing the viewed day & moment.
private struct FloorSummaryBar: View {
    let floor: Floor
    let viewingDate: Date
    let pinnedToNow: Bool

    private var busyCount: Int { floor.busyCount(at: viewingDate) }
    private var dayCount: Int { floor.eventCount(on: viewingDate) }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewingDate.formatted(.dateTime.weekday(.wide).month().day()))
                    .font(.headline)
                Text("\(dayCount) events scheduled")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if busyCount > 0 {
                Label(
                    pinnedToNow ? "\(busyCount) on now" : "\(busyCount) at this time",
                    systemImage: "dot.radiowaves.left.and.right"
                )
                .font(.caption.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.accentColor))
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

/// Color key explaining what the room tints mean.
private struct LegendBar: View {
    var body: some View {
        HStack(spacing: 18) {
            legendItem(color: MapStyle.busy, label: "Event on")
            legendItem(color: MapStyle.quiet, label: "Nothing on")
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.bar)
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .overlay(Circle().stroke(.secondary.opacity(0.4), lineWidth: 0.5))
                .frame(width: 10, height: 10)
            Text(label)
        }
    }
}

#Preview {
    VenueFloorPlanView(venue: SampleData.venue)
}
