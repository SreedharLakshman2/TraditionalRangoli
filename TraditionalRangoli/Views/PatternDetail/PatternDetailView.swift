import SwiftUI

struct PatternDetailView: View {
    let pattern: RangoliPattern
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var language: LanguageStore
    @State private var heart = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                RangoliPreview(motif: pattern.motif, animate: true)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .overlay(GoldCornerFrame().padding(12))
                    .goldFrame(cornerRadius: 28)
                    .shadow(color: Color.black.opacity(0.1), radius: 16, y: 8)

                Text(pattern.tamilTitle)
                    .font(RangoliFont.tamil(28))
                    .foregroundStyle(RangoliColor.ink)
                Text(pattern.localizedTitle(language.language))
                    .font(.rangoliScript(22, language: language.language))
                    .foregroundStyle(RangoliColor.muted)

                HStack(spacing: 8) {
                    MetaChip(text: pattern.family.localizedTitle(language.language))
                    MetaChip(text: language.format("pulliNxN", pattern.gridSize, pattern.gridSize))
                    MetaChip(text: language.format("stepsCount", pattern.stepCount))
                    MetaChip(text: language.format("minutesCount", pattern.estimatedMinutes))
                }

                if let festival = pattern.festivals.first {
                    MetaChip(text: festival.localizedTitle(language.language))
                }

                culturalNote

                Text(pattern.description)
                    .font(RangoliFont.body(16))
                    .foregroundStyle(RangoliColor.muted)
                    .fixedSize(horizontal: false, vertical: true)

                RangoliPrimaryButton(title: language.t("learnStepByStep"), icon: "hand.draw") {
                    router.studio = StudioRoute(kind: .guided(pattern))
                }
                .courtyardControls()
                RangoliSecondaryButton(title: language.t("drawFreely"), icon: "pencil.tip") {
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
                        Text(settings.favoritePatternIds.contains(pattern.id) ? language.t("favorited") : language.t("favorite"))
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

    private var culturalNote: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(language.t("whyThisKolam"))
                .font(RangoliFont.label(11))
                .tracking(1.3)
                .foregroundStyle(RangoliColor.gold)
            Text(pattern.localizedNote(language.language))
                .font(RangoliFont.body(16))
                .foregroundStyle(RangoliColor.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RangoliColor.paper, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .goldFrame(cornerRadius: 18)
    }

    private var inside: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(language.t("lessonTeaches"))
                .font(.rangoliScript(20, language: language.language))
                .foregroundStyle(RangoliColor.ink)
            ForEach(Array([
                language.t("teach1"),
                language.t("teach2"),
                language.t("teach3"),
                language.t("teach4")
            ].enumerated()), id: \.offset) { _, item in
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
