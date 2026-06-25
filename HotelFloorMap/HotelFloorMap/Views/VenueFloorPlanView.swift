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

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private let ticker = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    init(venue: Venue) {
        self.venue = venue
        _selectedFloorID = State(initialValue: venue.floors.first?.id ?? UUID())
    }

    private var selectedFloor: Floor {
        venue.floors.first { $0.id == selectedFloorID } ?? venue.floors[0]
    }

    /// Use a side-panel layout when there is generous horizontal space (iPad) or
    /// limited vertical space (landscape iPhone).
    private var useWideLayout: Bool {
        horizontalSizeClass == .regular || verticalSizeClass == .compact
    }

    /// Fixed 7 AM – 7 PM conference-day window.
    private var hourRange: ClosedRange<Double> { 7...19 }

    var body: some View {
        NavigationStack {
            Group {
                if useWideLayout {
                    wideLayout
                } else {
                    compactLayout
                }
            }
            .navigationTitle(venue.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarVisibility(useWideLayout ? .hidden : .automatic, for: .navigationBar)
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

    // MARK: - Portrait iPhone layout

    /// Vertical stack: summary bar, map, time scrubber, legend.
    private var compactLayout: some View {
        VStack(spacing: 0) {
            FloorSummaryBar(floor: selectedFloor, viewingDate: viewingDate, pinnedToNow: pinnedToNow)
            mapContent
            timeScrubber
            LegendBar()
        }
    }

    // MARK: - Landscape / iPad layout

    /// Map fills the leading area; controls sit in a trailing side panel.
    private var wideLayout: some View {
        HStack(spacing: 0) {
            mapContent
            Divider()
            controlsPanel
        }
    }

    private var controlsPanel: some View {
        VStack(spacing: 0) {
            // Header replacing the navigation bar in wide layout
            HStack {
                Button { showingSettings = true } label: {
                    Image(systemName: "gearshape")
                }
                Spacer()
                Text(venue.name).font(.headline)
                Spacer()
                if venue.floors.count > 1 {
                    FloorPicker(floors: venue.floors, selection: $selectedFloorID, now: viewingDate)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            Divider()
            FloorSummaryBar(floor: selectedFloor, viewingDate: viewingDate, pinnedToNow: pinnedToNow)
            Divider()
            TimeScrubber(
                days: selectedFloor.eventDays,
                hourRange: hourRange,
                selectedDate: $viewingDate,
                isPinnedToNow: pinnedToNow,
                onScrub: { pinnedToNow = false },
                onJumpToNow: {
                    pinnedToNow = true
                    viewingDate = now
                },
                compact: true
            )
            Divider()
            LegendBar()
            Spacer(minLength: 0)
        }
        .frame(width: horizontalSizeClass == .regular ? 340 : 280)
        .ignoresSafeArea(edges: .bottom)
        .background(.bar)
    }

    // MARK: - Shared subviews

    private var mapContent: some View {
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
        .background(MapStyle.mapBackground)
    }

    private var timeScrubber: some View {
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
        .accessibilityElement(children: .combine)
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
            legendItem(color: MapStyle.busy, label: "Session on")
            legendItem(color: MapStyle.quiet, label: "Empty")
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.bar)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Legend: dark blue means session on, light means empty")
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

#Preview("Portrait") {
    VenueFloorPlanView(venue: SampleData.venue)
}

#Preview("Portrait Dark") {
    VenueFloorPlanView(venue: SampleData.venue)
        .preferredColorScheme(.dark)
}

#Preview("Landscape", traits: .landscapeLeft) {
    VenueFloorPlanView(venue: SampleData.venue)
}

#Preview("Landscape Dark", traits: .landscapeLeft) {
    VenueFloorPlanView(venue: SampleData.venue)
        .preferredColorScheme(.dark)
}
