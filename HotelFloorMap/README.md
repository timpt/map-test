# Hotel Floor Map

A SwiftUI app (iOS 26+) for a single event venue. It opens directly to an
interactive floor plan where each room/area shows the meetings and events
assigned to it.

## Flow

1. **Floor plan** (`VenueFloorPlanView`) — the app's root. An interactive,
   to-scale plan of the venue. Switch floors from the toolbar. **Pinch to zoom
   and drag to pan** (a reset control appears when zoomed). A summary strip
   shows how many events are scheduled and how many are live right now. Spaces
   are color-coded:
   - 🔴 **Red** — an event is happening now
   - 🔵 **Blue** — events scheduled today
   - ⚪️ **Gray** — available / not bookable
2. **Space detail** (`SpaceDetailView`) — tap any room to open a sheet listing
   that space's events, grouped into *Happening Now*, *Later Today*, and
   *Earlier Today*. Empty rooms show a **Book This Space** action.
3. **Add event** (`AddEventView`) — book a new event (title, category, time,
   host, attendees, notes) into a space; it appears live on the plan.
4. **Event detail** (`EventDetailView`) — time, duration, host, attendees, notes.

Events in the sample data are anchored to *today*, so "live" highlighting
reflects the actual time of day you run the app (it refreshes every 30s).

## Project layout

```
HotelFloorMap/
├── HotelFloorMapApp.swift     App entry point (opens the floor plan)
├── Models/                    Venue, Floor, Space, Event, EventCategory
├── Stores/VenueStore.swift    @Observable store; supports booking new events
├── Data/SampleData.swift      One demo venue with two floors of spaces & events
└── Views/
    ├── VenueFloorPlanView.swift  Root: floor selector, summary, plan, legend
    ├── ZoomPanView.swift         Reusable pinch-zoom + drag-pan container
    ├── FloorPlanView.swift       Renders tappable spaces from normalized polygons
    ├── SpacePolygon.swift        Shape used to draw & hit-test a room footprint
    ├── SpaceDetailView.swift     Events in a tapped space (sheet)
    ├── AddEventView.swift        Form to book a new event into a space
    └── EventRow.swift / EventDetailView.swift
```

## Running

Open `HotelFloorMap.xcodeproj` in **Xcode 26+**, select an iOS 26 simulator,
and run. The project uses file-system–synchronized groups, so new files added
to the `HotelFloorMap/` folder are picked up automatically.

## Design notes

- A `Venue` has one or more `Floor`s, each containing `Space`s (rooms/areas).
  Each `Space` holds the `Event`s assigned to it.
- Each `Space` stores its footprint as a **normalized polygon** (`[CGPoint]`,
  0–1 on both axes), so rooms can be non-rectangular (the Main Lobby is an
  L-shape). A `rect:` convenience initializer covers the common rectangular
  case. `FloorPlanView` scales each polygon to the available area and uses it
  for both drawing and hit-testing, so corridors/gaps between rooms aren't
  tappable.
- State lives in an `@Observable VenueStore`. Booking an event mutates the store
  and the plan + sheet update live (highlighting refreshes every 30s).
- All data is in-memory sample data — there is no backend. Swapping in a real
  data source means replacing `SampleData`/`VenueStore` with your own models.
