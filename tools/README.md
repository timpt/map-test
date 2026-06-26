# Tools

## room-tracer.html

A self-contained browser tool for tracing room border polygons over the JW
Marriott floor plan. The floor-plan image is embedded as a base64 data URL, so
the file works offline with no dependencies.

**Usage:** open in any browser → click each corner of the current room (it
auto-closes the shape) → "Finish room & go to next" → repeat → "Export
coordinates" and copy the JSON. Those coordinates feed the room polygons in
`HotelFloorMap/HotelFloorMap/Data/SampleData.swift`.
