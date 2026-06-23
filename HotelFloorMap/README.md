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
   are scheduled and how many are live right now. Rooms are tinted by status:
   - 🔴 **Red** — an event is happening now
   - 🔵 **Blue** — events scheduled today
   - ⚪️ **None** — available (the drawing shows through; still tappable)
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
│   └── floorplan.imageset/    The real venue floor-plan drawing (SVG)
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

- A `Floor` references a plan drawing via `imageName` (an asset-catalog image).
  `FloorPlanView` renders that image aspect-fit, then overlays each room as a
  hotspot positioned in the drawing's normalized (0...1) coordinate space.
- Each `Space` stores its footprint as a **normalized polygon** (`[CGPoint]`)
  traced onto the drawing. The same polygon is used to tint the room by status
  and to hit-test taps, so only the room area is tappable. (A `rect:`
  convenience initializer exists for venues drawn as abstract boxes — when a
  floor has no `imageName`.)
- The room *names* come from the drawing itself, so the overlay stays light
  (translucent tints only) and doesn't duplicate labels.
- All data is in-memory sample data — there is no backend. To show a different
  floor/venue, swap the asset image and replace `SampleData` with your own
  `Venue`/`Floor`/`Space`/`Event` values (polygons traced onto the new image).

## Reproducing the room tracing

The room hotspots were traced by rendering the floor-plan SVG to PNG and
compositing candidate polygons back over it to check alignment. That tooling
isn't part of the app; it lived in a scratch workspace during development.
