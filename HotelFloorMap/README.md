# Hotel Floor Map

A SwiftUI app (iOS 26+) for a single event venue. It opens directly to an
interactive floor plan where each room/area shows the meetings and events
assigned to it.

## Flow

1. **Floor plan** (`VenueFloorPlanView`) — the app's root. An interactive,
   to-scale plan of the venue. Switch floors from the toolbar. A summary strip
   shows how many events are scheduled and how many are live right now. Spaces
   are color-coded:
   - 🔴 **Red** — an event is happening now
   - 🔵 **Blue** — events scheduled today
   - ⚪️ **Gray** — available / not bookable
2. **Space detail** (`SpaceDetailView`) — tap any room to open a sheet listing
   that space's events, grouped into *Happening Now*, *Later Today*, and
   *Earlier Today*.
3. **Event detail** (`EventDetailView`) — time, duration, host, attendees, notes.

Events in the sample data are anchored to *today*, so "live" highlighting
reflects the actual time of day you run the app (it refreshes every 30s).

## Project layout

```
HotelFloorMap/
├── HotelFloorMapApp.swift     App entry point (opens the floor plan)
├── Models/                    Venue, Floor, Space, Event, EventCategory
├── Data/SampleData.swift      One demo venue with two floors of spaces & events
└── Views/
    ├── VenueFloorPlanView.swift  Root: floor selector, summary, plan, legend
    ├── FloorPlanView.swift       Renders tappable spaces from normalized rects
    ├── SpaceDetailView.swift     Events in a tapped space (sheet)
    └── EventRow.swift / EventDetailView.swift
```

## Running

Open `HotelFloorMap.xcodeproj` in **Xcode 26+**, select an iOS 26 simulator,
and run. The project uses file-system–synchronized groups, so new files added
to the `HotelFloorMap/` folder are picked up automatically.

## Design notes

- A `Venue` has one or more `Floor`s, each containing `Space`s (rooms/areas).
  Each `Space` holds the `Event`s assigned to it.
- Each `Space` stores its footprint as a **normalized `CGRect`** (0–1 on both
  axes). `FloorPlanView` scales these to the available area, so the plan stays
  crisp at any size or orientation. Editing a room's position/size is just
  editing its rect in `SampleData`.
- All data is in-memory sample data — there is no backend. Swapping in a real
  data source means replacing `SampleData` with your own models.
