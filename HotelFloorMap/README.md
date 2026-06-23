# Hotel Floor Map

A SwiftUI app (iOS 26+) that shows hotels on a map, then drills into an
interactive floor plan where each space displays the events assigned to it.

## Flow

1. **Properties map** (`HotelMapView`) — a MapKit map with a pin per hotel.
   Each pin is badged with the number of events that are *live right now*.
   Tap a pin to reveal a glass summary card, then **View Floor Maps**.
2. **Floor map** (`FloorMapView`) — an interactive, to-scale floor plan.
   Switch floors from the toolbar. Spaces are color-coded:
   - 🔴 **Red** — an event is happening now
   - 🔵 **Blue** — events scheduled today
   - ⚪️ **Gray** — available / not bookable
3. **Space detail** (`SpaceDetailView`) — a sheet listing that space's events,
   grouped into *Happening Now*, *Later Today*, and *Earlier Today*.
4. **Event detail** (`EventDetailView`) — time, duration, host, attendees, notes.

Events in the sample data are anchored to *today*, so "live" highlighting
reflects the actual time of day you run the app (it refreshes every 30s).

## Project layout

```
HotelFloorMap/
├── HotelFloorMapApp.swift     App entry point
├── Models/                    Hotel, Floor, Space, Event, EventCategory
├── Data/SampleData.swift      Two demo hotels with floors, spaces & events
└── Views/
    ├── HotelMapView.swift       Map of properties
    ├── FloorMapView.swift       Floor selector + plan container
    ├── FloorPlanView.swift      Renders tappable spaces from normalized rects
    ├── SpaceDetailView.swift    Events in a tapped space (sheet)
    ├── EventRow.swift / EventDetailView.swift
    └── GlassCardBackground.swift  iOS 26 Liquid Glass helper (with fallback)
```

## Running

Open `HotelFloorMap.xcodeproj` in **Xcode 26+**, select an iOS 26 simulator,
and run. The project uses file-system–synchronized groups, so new files added
to the `HotelFloorMap/` folder are picked up automatically.

## Design notes

- Each `Space` stores its footprint as a **normalized `CGRect`** (0–1 on both
  axes). `FloorPlanView` scales these to the available area, so the plan stays
  crisp at any size or orientation.
- `GlassCardBackground` uses the iOS 26 `.glassEffect(...)` Liquid Glass API,
  falling back to `.ultraThinMaterial` on earlier systems.
- All data is in-memory sample data — there is no backend. Swapping in a real
  data source means replacing `SampleData` with your own models.
