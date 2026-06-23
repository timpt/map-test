import SwiftUI
import MapKit

/// Top-level screen: a geographic map with a pin per hotel. Tapping a pin (or
/// its callout) drills into that hotel's floor maps.
struct HotelMapView: View {
    private let hotels = SampleData.hotels

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 38.37, longitude: -121.18),
            span: MKCoordinateSpan(latitudeDelta: 4.5, longitudeDelta: 4.5)
        )
    )
    @State private var selectedHotel: Hotel?
    @State private var path: [Hotel] = []

    var body: some View {
        NavigationStack(path: $path) {
            Map(position: $cameraPosition, selection: $selectedHotel) {
                ForEach(hotels) { hotel in
                    Annotation(
                        hotel.name,
                        coordinate: hotel.coordinate,
                        anchor: .bottom
                    ) {
                        HotelMapMarker(
                            hotel: hotel,
                            isSelected: selectedHotel?.id == hotel.id
                        )
                        .onTapGesture { selectedHotel = hotel }
                    }
                    .tag(hotel)
                }
            }
            .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll))
            .mapControls {
                MapCompass()
                MapScaleView()
            }
            .overlay(alignment: .bottom) {
                if let hotel = selectedHotel {
                    HotelSummaryCard(hotel: hotel) {
                        path.append(hotel)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.snappy, value: selectedHotel)
            .navigationTitle("Properties")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Hotel.self) { hotel in
                FloorMapView(hotel: hotel)
            }
        }
    }
}

/// The custom pin shown for each hotel, badged with a live-event count.
private struct HotelMapMarker: View {
    let hotel: Hotel
    let isSelected: Bool

    private var liveCount: Int { hotel.liveEventCount() }

    var body: some View {
        VStack(spacing: 2) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "building.2.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle().fill(isSelected ? Color.accentColor : Color.blue.gradient)
                    )
                    .overlay(Circle().stroke(.white, lineWidth: 2))
                    .shadow(radius: isSelected ? 6 : 3)

                if liveCount > 0 {
                    Text("\(liveCount)")
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                        .padding(5)
                        .background(Circle().fill(.red))
                        .overlay(Circle().stroke(.white, lineWidth: 1.5))
                        .offset(x: 6, y: -6)
                }
            }
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 10))
                .foregroundStyle(isSelected ? Color.accentColor : Color.blue)
                .offset(y: -4)
        }
        .scaleEffect(isSelected ? 1.15 : 1)
        .animation(.spring(duration: 0.25), value: isSelected)
    }
}

/// Bottom card summarizing the selected hotel with a button to open its floors.
private struct HotelSummaryCard: View {
    let hotel: Hotel
    let onOpen: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(hotel.name)
                    .font(.headline)
                Text(hotel.address)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 16) {
                Label("\(hotel.floors.count) floors", systemImage: "square.stack.3d.up.fill")
                Label("\(hotel.eventCount) events today", systemImage: "calendar")
                if hotel.liveEventCount() > 0 {
                    Label("\(hotel.liveEventCount()) live", systemImage: "dot.radiowaves.left.and.right")
                        .foregroundStyle(.red)
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            Button(action: onOpen) {
                Label("View Floor Maps", systemImage: "map.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCardBackground()
    }
}

#Preview {
    HotelMapView()
}
