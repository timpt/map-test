import SwiftUI

/// The kind of event held in a space. Drives the color & icon used throughout the UI.
enum EventCategory: String, CaseIterable, Identifiable, Hashable {
    case conference = "Conference"
    case wedding = "Wedding"
    case banquet = "Banquet"
    case meeting = "Meeting"
    case workshop = "Workshop"
    case social = "Social"
    case fitness = "Fitness"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .conference: return "person.3.fill"
        case .wedding: return "heart.fill"
        case .banquet: return "fork.knife"
        case .meeting: return "bubble.left.and.bubble.right.fill"
        case .workshop: return "hammer.fill"
        case .social: return "wineglass.fill"
        case .fitness: return "figure.run"
        }
    }

    var tint: Color {
        switch self {
        case .conference: return .blue
        case .wedding: return .pink
        case .banquet: return .orange
        case .meeting: return .teal
        case .workshop: return .purple
        case .social: return .indigo
        case .fitness: return .green
        }
    }
}
