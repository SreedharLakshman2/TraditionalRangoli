import SwiftUI

struct PatternDetailView: View {
    let pattern: RangoliPattern
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var heart = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                RangoliPreview(motif: pattern.motif, animate: true)
                    .frame(height: sizeClass == .regular ? 360 : 280)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .overlay(GoldCornerFrame().padding(12))
                    .goldFrame(cornerRadius: 28)
                    .shadow(color: Color.black.opacity(0.1), radius: 16, y: 8)

                Text(pattern.title)
                    .font(RangoliFont.display(28))
                    .foregroundStyle(RangoliColor.ink)

                HStack(spacing: 8) {
                    MetaChip(text: pattern.difficulty.title)
                    MetaChip(text: "\(pattern.gridSize) × \(pattern.gridSize) dots")
                    MetaChip(text: "\(pattern.stepCount) steps")
                    MetaChip(text: "\(pattern.estimatedMinutes) min")
                }

                Text(pattern.description)
                    .font(RangoliFont.body(16))
                    .foregroundStyle(RangoliColor.muted)
                    .fixedSize(horizontal: false, vertical: true)

                RangoliPrimaryButton(title: "Learn Step-by-Step", icon: "hand.draw") {
                    router.studio = StudioRoute(kind: .guided(pattern))
                }
                .courtyardControls()
                RangoliSecondaryButton(title: "Start Drawing", icon: "pencil.tip") {
                    router.studio = StudioRoute(kind: .dots(pattern))
                }
                .courtyardControls()
                Button {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.55)) {
                        settings.toggleFavorite(patternId: pattern.id)
                        heart.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: settings.favoritePatternIds.contains(pattern.id) ? "heart.fill" : "heart")
                            .foregroundStyle(RangoliColor.primary)
                            .scaleEffect(heart ? 1.15 : 1)
                        Text(settings.favoritePatternIds.contains(pattern.id) ? "Favorited" : "Favorite")
                            .font(RangoliFont.headline(16))
                            .foregroundStyle(RangoliColor.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .buttonStyle(PressScaleStyle())
                .courtyardControls()

                inside
            }
            .padding(20)
            .padding(.bottom, 16)
            .courtyardColumn()
        }
        .background(PaperBackground(showWatermark: false).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    private var inside: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What's inside")
                .font(RangoliFont.title(20))
                .foregroundStyle(RangoliColor.ink)
            ForEach(Array(["Dot placement", "Symmetry", "Guided strokes", "Coloring"].enumerated()), id: \.offset) { _, item in
                HStack(spacing: 12) {
                    Circle()
                        .fill(RangoliColor.gold)
                        .frame(width: 8, height: 8)
                    Text(item)
                        .font(RangoliFont.body(16))
                        .foregroundStyle(RangoliColor.ink)
                    Spacer()
                }
                .padding(12)
                .background(RangoliColor.paper, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
    }
}
