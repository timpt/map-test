import SwiftUI

@main
struct HotelFloorMapApp: App {
    @State private var store = ConferenceStore(venue: SampleData.venue)
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(store)
                .onOpenURL { store.handleDeepLink($0) }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background {
                store.saveNavigationState()
            }
        }
    }
}
