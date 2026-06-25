import SwiftUI
import UIKit

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
    /// When true, the time label sits above the slider instead of beside it.
    var compact: Bool = false

    private let calendar = Calendar.current
    private let haptic = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                dayPicker
                Spacer(minLength: 8)
                nowButton
            }

            if compact {
                VStack(spacing: 4) {
                    Text(timeLabel)
                        .font(.subheadline.weight(.semibold).monospacedDigit())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Slider(value: hourBinding, in: hourRange, step: 0.5)
                        .accessibilityLabel("Time")
                        .accessibilityValue(timeLabel)
                    SliderTicks(hourRange: hourRange)
                        .accessibilityHidden(true)
                }
            } else {
                HStack(spacing: 12) {
                    Text(timeLabel)
                        .font(.subheadline.weight(.semibold).monospacedDigit())
                        .frame(width: 92, alignment: .leading)
                    VStack(spacing: 2) {
                        Slider(value: hourBinding, in: hourRange, step: 0.5)
                            .accessibilityLabel("Time")
                            .accessibilityValue(timeLabel)
                        SliderTicks(hourRange: hourRange)
                            .accessibilityHidden(true)
                    }
                }
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
                .accessibilityLabel(day.formatted(.dateTime.weekday(.wide).month().day()))
                .accessibilityAddTraits(isSelected ? .isSelected : [])
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
                    if updated != selectedDate { haptic.impactOccurred() }
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

/// Hour and half-hour tick marks aligned with the slider track.
private struct SliderTicks: View {
    let hourRange: ClosedRange<Double>

    /// Approximate inset of the slider thumb center from the view edge.
    private let thumbInset: CGFloat = 14

    /// Show hour labels at every step to avoid crowding.
    private var labelStep: Int {
        let span = Int(hourRange.upperBound - hourRange.lowerBound)
        if span <= 14 { return 1 }
        return 2
    }

    var body: some View {
        GeometryReader { geo in
            let trackWidth = geo.size.width - thumbInset * 2
            let span = hourRange.upperBound - hourRange.lowerBound

            // Tick lines via Canvas (half-hour + hour ticks)
            Canvas { ctx, size in
                var h = (ceil(hourRange.lowerBound * 2) / 2)
                while h <= hourRange.upperBound {
                    let isWhole = h.truncatingRemainder(dividingBy: 1) == 0
                    let x = Double(thumbInset) + (h - hourRange.lowerBound) / span * Double(trackWidth)
                    let tickH: CGFloat = isWhole ? 5 : 3
                    let rect = CGRect(x: x - 0.5, y: 0, width: 1, height: tickH)
                    ctx.fill(Path(rect), with: .color(.secondary.opacity(isWhole ? 0.5 : 0.25)))
                    h += 0.5
                }
            }
            .frame(height: 5)

            // Hour labels
            let first = Int(ceil(hourRange.lowerBound))
            let last = Int(hourRange.upperBound)
            ForEach(Array(stride(from: first, through: last, by: labelStep)), id: \.self) { hour in
                let x = thumbInset + CGFloat((Double(hour) - hourRange.lowerBound) / span) * trackWidth
                Text(hourLabel(hour))
                    .font(.system(size: 9))
                    .foregroundStyle(.tertiary)
                    .fixedSize()
                    .position(x: x, y: 12)
            }
        }
        .frame(height: 18)
    }

    private func hourLabel(_ h: Int) -> String {
        let display = h % 12
        let suffix = h < 12 || h == 24 ? "a" : "p"
        return "\(display == 0 ? 12 : display)\(suffix)"
    }
}

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
