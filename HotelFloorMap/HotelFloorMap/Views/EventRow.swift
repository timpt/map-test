import SwiftUI

/// A compact row representing one event inside a space.
struct EventRow: View {
    let event: Event
    let now: Date

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: event.category.symbolName)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(event.category.tint.gradient, in: .rect(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                Text(event.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Text(event.timeRangeText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Label("\(event.attendeeCount)", systemImage: "person.fill")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if event.isLive(at: now) {
                Text("LIVE")
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(.red))
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        EventRow(event: SampleData.grandHarbor.floors[0].spaces[1].events[0], now: .now)
    }
}
