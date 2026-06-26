import SwiftUI

/// Keys used to persist user preferences, shared so any view can read them
/// via `@AppStorage`.
enum SettingsKey {
    static let livePulse = "livePulseEnabled"
}

/// App-wide settings, shown as its own tab.
struct SettingsView: View {
    @AppStorage(SettingsKey.livePulse) private var livePulseEnabled = true

    var body: some View {
        Form {
            Section {
                Toggle("Live pulse", isOn: $livePulseEnabled)
            } header: {
                Text("Map")
            } footer: {
                Text("Gently fade rooms with a session on. Only animates while the map is following the live clock.")
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
