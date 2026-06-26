import SwiftUI

/// The app's single source of truth for venue data, the live clock, and
/// navigation state. Injected into the environment at the app root.
@Observable
final class ConferenceStore {

    // MARK: - Data

    let venue: Venue

    // MARK: - Clock

    /// The authoritative "now" for the entire app, ticked every 30 seconds.
    /// Views that need the current time read this instead of maintaining
    /// their own timers.
    private(set) var now: Date = .now

    // MARK: - Navigation State

    var selectedTab: AppTab = .info
    var paths = TabPaths()
    var showingMap = false
    var showingNotifications = false
    var showingProfile = false

    // MARK: - Timer

    private var timer: Foundation.Timer?

    init(venue: Venue) {
        self.venue = venue
        restoreNavigationState()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.now = .now
            }
        }
    }

    deinit {
        timer?.invalidate()
    }

    // MARK: - Live session queries

    /// The first live event across all floors, with its space name.
    var liveSession: (event: Event, spaceName: String)? {
        for floor in venue.floors {
            for space in floor.spaces {
                if let event = space.event(at: now) {
                    return (event, space.name)
                }
            }
        }
        return nil
    }

    /// The soonest upcoming event if nothing is live.
    var nextSession: (event: Event, spaceName: String)? {
        var best: (event: Event, spaceName: String)?
        for floor in venue.floors {
            for space in floor.spaces {
                for event in space.upcomingEvents(at: now) {
                    if best == nil || event.start < best!.event.start {
                        best = (event, space.name)
                    }
                }
            }
        }
        return best
    }

    // MARK: - Deep Linking

    func handleDeepLink(_ url: URL) {
        guard url.scheme == "hotelfloormap" else { return }
        guard let host = url.host() else { return }

        switch host {
        case "tab":
            let tabName = url.pathComponents.dropFirst().first ?? ""
            if let tab = AppTab(rawValue: tabName) {
                selectedTab = tab
            }
        case "map":
            showingMap = true
        case "notifications":
            showingNotifications = true
        case "profile":
            showingProfile = true
        default:
            break
        }
    }

    // MARK: - State Restoration

    private enum RestorationKey {
        static let selectedTab = "restoration.selectedTab"
        static let showingMap = "restoration.showingMap"
    }

    func saveNavigationState() {
        UserDefaults.standard.set(selectedTab.rawValue, forKey: RestorationKey.selectedTab)
        UserDefaults.standard.set(showingMap, forKey: RestorationKey.showingMap)
    }

    private func restoreNavigationState() {
        if let raw = UserDefaults.standard.string(forKey: RestorationKey.selectedTab),
           let tab = AppTab(rawValue: raw) {
            selectedTab = tab
        }
        showingMap = UserDefaults.standard.bool(forKey: RestorationKey.showingMap)
    }
}

// MARK: - Supporting types

enum AppTab: String, Hashable {
    case info, agenda, directory, settings, search
}

/// Per-tab navigation paths so each tab preserves its own stack.
@Observable
final class TabPaths {
    var info = NavigationPath()
    var agenda = NavigationPath()
    var directory = NavigationPath()
    var settings = NavigationPath()
    var search = NavigationPath()
}
