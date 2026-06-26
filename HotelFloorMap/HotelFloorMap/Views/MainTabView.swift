import SwiftUI

struct MainTabView: View {
    @Environment(ConferenceStore.self) private var store

    var body: some View {
        @Bindable var store = store

        TabView(selection: $store.selectedTab) {
            tab("Info", systemImage: "info.circle", value: .info, path: $store.paths.info)
            tab("Agenda", systemImage: "calendar", value: .agenda, path: $store.paths.agenda)
            tab("Directory", systemImage: "person.2", value: .directory, path: $store.paths.directory)

            Tab("Settings", systemImage: "gearshape", value: .settings) {
                NavigationStack(path: $store.paths.settings) {
                    SettingsView()
                        .toolbar { commonToolbar }
                }
            }

            Tab(value: .search, role: .search) {
                NavigationStack(path: $store.paths.search) {
                    PlaceholderView(title: "Search", systemImage: "magnifyingglass")
                        .toolbar { commonToolbar }
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewBottomAccessory {
            NowPlayingAccessory()
        }
        .fullScreenCover(isPresented: $store.showingMap) {
            NavigationStack {
                VenueFloorPlanView()
                    .environment(store as ConferenceStore)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Done") { store.showingMap = false }
                        }
                    }
            }
        }
        .sheet(isPresented: $store.showingNotifications) {
            NotificationsView()
        }
        .sheet(isPresented: $store.showingProfile) {
            ProfileView()
        }
    }

    // MARK: - Helpers

    /// A placeholder tab with a navigation stack and common toolbar.
    @TabContentBuilder<AppTab>
    private func tab(_ title: String, systemImage: String, value: AppTab, path: Binding<NavigationPath>) -> some TabContent<AppTab> {
        Tab(title, systemImage: systemImage, value: value) {
            NavigationStack(path: path) {
                PlaceholderView(title: title, systemImage: systemImage)
                    .toolbar { commonToolbar }
            }
        }
    }

    @ToolbarContentBuilder
    private var commonToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button { store.showingNotifications = true } label: {
                Label("Notifications", systemImage: "bell")
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button { store.showingMap = true } label: {
                Label("Map", systemImage: "map")
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button { store.showingProfile = true } label: {
                Label("Profile", systemImage: "person.circle")
            }
        }
    }
}

/// Temporary placeholder for tabs that haven't been built yet.
private struct PlaceholderView: View {
    let title: String
    let systemImage: String

    var body: some View {
        ContentUnavailableView(title, systemImage: systemImage, description: Text("Coming soon"))
            .navigationTitle(title)
    }
}

/// A compact "now playing" strip showing the next or current live session.
/// Adapts between expanded (above tab bar) and inline (collapsed tab bar).
private struct NowPlayingAccessory: View {
    @Environment(ConferenceStore.self) private var store
    @Environment(\.tabViewBottomAccessoryPlacement) private var placement

    var body: some View {
        if let session = store.liveSession {
            accessoryContent(
                icon: "dot.radiowaves.left.and.right",
                title: session.event.title,
                subtitle: session.spaceName,
                isLive: true
            )
        } else if let session = store.nextSession {
            let timeText = session.event.start.formatted(.dateTime.hour().minute())
            accessoryContent(
                icon: "arrow.forward.circle",
                title: session.event.title,
                subtitle: "\(session.spaceName) · \(timeText)",
                isLive: false
            )
        }
    }

    @ViewBuilder
    private func accessoryContent(icon: String, title: String, subtitle: String, isLive: Bool) -> some View {
        switch placement {
        case .inline:
            Label(title, systemImage: icon)
                .font(.caption)
                .lineLimit(1)
        default:
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundStyle(isLive ? Color.accentColor : .secondary)
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.caption.bold())
                        .lineLimit(1)
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer(minLength: 0)
                if isLive {
                    Text("LIVE")
                        .font(.system(size: 9, weight: .heavy))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.accentColor))
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    MainTabView()
        .environment(ConferenceStore(venue: SampleData.venue))
}
