# Hotel Floor Map

A SwiftUI app (iOS 26+) that displays the events happening across a venue's
event spaces, overlaid on the venue's **real floor-plan drawing**. It opens
directly to the interactive plan where each room shows the meetings and events
scheduled in it. **Display-only** — it visualizes the schedule, it doesn't book
or edit events.

The floor plan is the **JW Marriott Reston Station** (Reston, VA) Third Level
event space — the actual venue drawing (`floorplan` in the asset catalog,
rendered from the hotel's published SVG). Room hotspots are traced onto that
drawing; the events are illustrative sample data.

## Flow

1. **Floor plan** (`VenueFloorPlanView`) — the app's root. The real plan drawing
   with a tappable hotspot over each room. **Pinch to zoom and drag to pan**
   (a reset control appears when zoomed). A summary strip shows how many events
   are scheduled and how many are live right now. The map is **fully app-drawn**:
   each room is a styled, labeled, status-colored shape sitting on the venue's
   real building footprint (derived from the plan) — a clean, custom Apple-style
   indoor map:
   - 🔴 **Red** — an event is happening now
   - 🔵 **Blue** — events scheduled today
   - ⚪️ **White** — available
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
├── Data/SampleData.swift      The venue, its floor, rooms & their events
├── Assets.xcassets/
│   └── floorplanFootprint.imageset/  Venue building outline (gray PNG, derived from the plan)
└── Views/
    ├── VenueFloorPlanView.swift  Root: summary bar, plan, legend
    ├── ZoomPanView.swift         Reusable pinch-zoom + drag-pan container
    ├── FloorPlanView.swift       Renders the plan image + tappable room hotspots
    ├── SpacePolygon.swift        Shape used to draw & hit-test a room footprint
    ├── SpaceDetailView.swift     Events in a tapped room (sheet)
    └── EventRow.swift / EventDetailView.swift
```

## Running

Open `HotelFloorMap.xcodeproj` in **Xcode 26+**, select an iOS 26 simulator,
and run. The project uses file-system–synchronized groups, so new files added
to the `HotelFloorMap/` folder are picked up automatically.

## Design notes

- `FloorPlanView` draws, in a fitted rect: a warm background, the building
  **footprint** image (`floor.imageName`, `.allowsHitTesting(false)`), then each
  room on top as a `RoomCell` — a status-colored fill with a white separator and
  a centered app-drawn label. This branch is fully app-drawn (no scanned walls).
- The footprint PNG is derived from the venue plan by flood-filling the exterior
  and keeping the interior silhouette (see scratch tooling note below).
- Each `Space` stores its footprint as a **normalized polygon** (`[CGPoint]`)
  in that image's (0...1) coordinate space; the same polygon is the fill shape
  and the hit-test area. (A `rect:` convenience initializer also exists.)
- All data is in-memory sample data — there is no backend. To show a different
  floor/venue, swap the asset image and replace `SampleData` with your own
  `Venue`/`Floor`/`Space`/`Event` values (polygons traced onto the new image).

## Reproducing the room tracing

The room hotspots were traced by rendering the floor-plan SVG to PNG and
compositing candidate polygons back over it to check alignment. That tooling
isn't part of the app; it lived in a scratch workspace during development.
