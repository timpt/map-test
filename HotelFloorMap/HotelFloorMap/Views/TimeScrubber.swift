import SwiftUI

/// A day selector + time slider that sets the moment the map reflects. Picking a
/// day or dragging the slider scrubs the "viewing time"; the map and detail sheet
/// recolor to show what's on at that instant. A "Now" button re-pins to the
/// current time.
struct TimeScrubber: View {
    /// Conference days, each at start-of-day, ascending.
    let days: [Date]
    /// Hour-of-day bounds for the slider (e.g. 8.0 ... 23.0).
    let hourRange: ClosedRange<Double>
    /// The moment the map is showing.
    @Binding var selectedDate: Date
    /// Whether the view is currently pinned to the live clock.
    let isPinnedToNow: Bool
    /// Called whenever the user scrubs (so the caller can unpin from "now").
    let onScrub: () -> Void
    /// Called when the user taps "Now".
    let onJumpToNow: () -> Void

    private let calendar = Calendar.current

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                dayPicker
                Spacer(minLength: 8)
                nowButton
            }

            HStack(spacing: 12) {
                Text(timeLabel)
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .frame(width: 92, alignment: .leading)
                Slider(value: hourBinding, in: hourRange)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.bar)
    }

    // MARK: Day picker

    private var dayPicker: some View {
        HStack(spacing: 6) {
            ForEach(days, id: \.self) { day in
                let isSelected = calendar.isDate(day, inSameDayAs: selectedDate)
                Button {
                    select(day: day)
                } label: {
                    VStack(spacing: 1) {
                        Text(day.formatted(.dateTime.weekday(.abbreviated)))
                            .font(.caption2)
                        Text(day.formatted(.dateTime.day()))
                            .font(.callout.weight(.semibold))
                    }
                    .frame(minWidth: 38)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 9)
                            .fill(isSelected ? Color.accentColor : Color.clear)
                    )
                    .foregroundStyle(isSelected ? .white : .primary)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var nowButton: some View {
        Button(action: onJumpToNow) {
            Label("Now", systemImage: "dot.radiowaves.left.and.right")
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(isPinnedToNow ? Color.accentColor : Color.secondary.opacity(0.18))
                )
                .foregroundStyle(isPinnedToNow ? .white : .primary)
        }
        .buttonStyle(.plain)
    }

    // MARK: Time binding

    private var timeLabel: String {
        selectedDate.formatted(.dateTime.hour().minute())
    }

    /// Maps the slider's hour-of-day value to/from `selectedDate`.
    private var hourBinding: Binding<Double> {
        Binding(
            get: {
                let h = Double(calendar.component(.hour, from: selectedDate))
                let m = Double(calendar.component(.minute, from: selectedDate))
                return (h + m / 60).clamped(to: hourRange)
            },
            set: { newValue in
                onScrub()
                let hour = Int(newValue)
                let minute = Int((newValue - Double(hour)) * 60)
                if let updated = calendar.date(
                    bySettingHour: hour, minute: minute, second: 0, of: selectedDate
                ) {
                    selectedDate = updated
                }
            }
        )
    }

    private func select(day: Date) {
        onScrub()
        // Keep the current time-of-day, move it onto the chosen day.
        let comps = calendar.dateComponents([.hour, .minute], from: selectedDate)
        if let updated = calendar.date(
            bySettingHour: comps.hour ?? 12, minute: comps.minute ?? 0, second: 0, of: day
        ) {
            selectedDate = updated
        }
    }
}

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
