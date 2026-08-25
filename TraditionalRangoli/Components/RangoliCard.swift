import SwiftUI

struct RangoliCard: View {
    let pattern: RangoliPattern
    var large: Bool = false
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RangoliPreview(motif: pattern.motif, animate: large)
                .frame(height: previewHeight)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(GoldCornerFrame().padding(8))
            Text(pattern.title)
                .font(RangoliFont.headline(large ? 17 : 15))
                .foregroundStyle(RangoliColor.ink)
                .lineLimit(1)
            HStack(spacing: 8) {
                MetaChip(text: pattern.difficulty.title)
                MetaChip(text: "\(pattern.estimatedMinutes) min")
            }
        }
        .padding(12)
        .paperCard(radius: RangoliRadius.lg)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(pattern.title), \(pattern.difficulty.title), \(pattern.estimatedMinutes) minutes")
    }

    private var previewHeight: CGFloat {
        if large {
            return sizeClass == .regular ? 220 : 168
        }
        return 124
    }
}

struct CategoryCard: View {
    let title: String
    let symbol: String
    var motif: MotifKind
    @Environment(\.courtyardExpandedCards) private var expanded

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(symbol)
                    .font(.title2)
                Spacer()
                RangoliPreview(motif: motif, progress: 1)
                    .frame(width: 52, height: 52)
                    .clipShape(Circle())
            }
            Text(title)
                .font(RangoliFont.headline(15))
                .foregroundStyle(RangoliColor.ink)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
        .padding(14)
        .frame(width: expanded ? nil : 148, height: 118, alignment: .topLeading)
        .frame(maxWidth: expanded ? .infinity : 148, alignment: .topLeading)
        .paperCard(radius: RangoliRadius.md)
    }
}

struct MetaChip: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(RangoliFont.label(10))
            .tracking(0.6)
            .foregroundStyle(RangoliColor.maroon)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(RangoliColor.primary.opacity(0.08), in: Capsule())
    }
}

struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(RangoliFont.title(22))
                .foregroundStyle(RangoliColor.ink)
            if let subtitle {
                Text(subtitle)
                    .font(RangoliFont.caption(13))
                    .foregroundStyle(RangoliColor.muted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityAddTraits(.isHeader)
    }
}

struct ColorPaletteBar: View {
    @Binding var selection: PowderSwatch

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(PowderSwatch.allCases) { swatch in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selection = swatch
                        }
                    } label: {
                        Circle()
                            .fill(swatch.color)
                            .frame(width: selection == swatch ? 30 : 24, height: selection == swatch ? 30 : 24)
                            .overlay(Circle().stroke(RangoliColor.ink.opacity(selection == swatch ? 0.55 : 0.12), lineWidth: selection == swatch ? 2 : 1))
                            .shadow(color: swatch.color.opacity(0.35), radius: selection == swatch ? 6 : 0)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(swatch.title)
                    .accessibilityAddTraits(selection == swatch ? .isSelected : [])
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 6)
        }
    }
}

struct EmptyGallery: View {
    let title: String
    let subtitle: String
    let button: String
    var action: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            RangoliPreview(motif: .lotusDot, animate: true)
                .frame(width: 140, height: 140)
                .clipShape(Circle())
            Text(title)
                .font(RangoliFont.title(22))
                .foregroundStyle(RangoliColor.ink)
                .multilineTextAlignment(.center)
            Text(subtitle)
                .font(RangoliFont.body(15))
                .foregroundStyle(RangoliColor.muted)
                .multilineTextAlignment(.center)
            RangoliPrimaryButton(title: button, icon: "sparkles") { action() }
                .frame(width: 220)
        }
        .padding(28)
        .paperCard()
        .padding(.horizontal, 24)
    }
}
