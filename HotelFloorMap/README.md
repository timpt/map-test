# Hotel Floor Map

A SwiftUI app (iOS 26+) that displays the events happening across a venue's
event spaces. It opens directly to an interactive floor plan where each
room/area shows the meetings and events scheduled in it. **Display-only** — it
visualizes the schedule, it doesn't book or edit events.

The sample data is modeled on the **JW Marriott Reston Station** (Reston, VA),
using its publicly listed event spaces (Luminary Ballroom salons, Jewel Box,
Blank Canvas, ~40,000 sq ft on a single event level). Exact geometry and the
breakout "Studio" rooms are approximate.

## Flow

1. **Floor plan** (`VenueFloorPlanView`) — the app's root. An interactive,
   to-scale plan of the venue. Switch floors from the toolbar (Event Level /
   Lobby Level). **Pinch to zoom and drag to pan** (a reset control appears when
   zoomed). A summary strip shows how many events are scheduled and how many are
   live right now. Spaces are color-coded:
   - 🔴 **Red** — an event is happening now
   - 🔵 **Blue** — events scheduled today
   - ⚪️ **Gray** — available / not an event space
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
├── Data/SampleData.swift      The venue: two floors of spaces & their events
└── Views/
    ├── VenueFloorPlanView.swift  Root: floor selector, summary, plan, legend
    ├── ZoomPanView.swift         Reusable pinch-zoom + drag-pan container
    ├── FloorPlanView.swift       Renders tappable spaces from normalized polygons
    ├── SpacePolygon.swift        Shape used to draw & hit-test a room footprint
    ├── SpaceDetailView.swift     Events in a tapped space (sheet)
    └── EventRow.swift / EventDetailView.swift
```

## Running

Open `HotelFloorMap.xcodeproj` in **Xcode 26+**, select an iOS 26 simulator,
and run. The project uses file-system–synchronized groups, so new files added
to the `HotelFloorMap/` folder are picked up automatically.

## Design notes

- A `Venue` has one or more `Floor`s, each containing `Space`s (rooms/areas).
  Each `Space` holds the `Event`s scheduled in it.
- Each `Space` stores its footprint as a **normalized polygon** (`[CGPoint]`,
  0–1 on both axes), so rooms can be non-rectangular (the Hotel Lobby is an
  L-shape). A `rect:` convenience initializer covers the common rectangular
  case. `FloorPlanView` scales each polygon to the available area and uses it
  for both drawing and hit-testing, so corridors/gaps between rooms aren't
  tappable.
- All data is in-memory sample data — there is no backend. To show a different
  venue (or pull from a real scheduling system), replace `SampleData` with your
  own `Venue`/`Floor`/`Space`/`Event` values.
