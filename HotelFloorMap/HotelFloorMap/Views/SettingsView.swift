import SwiftUI

/// The key used to persist the live-pulse preference, shared so any view can
/// read it via `@AppStorage`.
enum SettingsKey {
    static let livePulse = "livePulseEnabled"
}

/// A small settings sheet for display preferences.
struct SettingsView: View {
    @AppStorage(SettingsKey.livePulse) private var livePulseEnabled = true
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Live pulse", isOn: $livePulseEnabled)
                } footer: {
                    Text("Gently fade rooms that have an event on right now. Only animates while the map is following the live clock.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
