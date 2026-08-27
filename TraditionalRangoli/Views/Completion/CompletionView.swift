import SwiftUI
import UIKit

struct CompletionView: View {
    let artwork: UserArtwork
    var pattern: RangoliPattern?
    var onClose: () -> Void

    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var artworks: ArtworkStore
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var language: LanguageStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var shownXP = 0
    @State private var petals = false
    @State private var saved = false
    @State private var favorited = false
    @State private var shareURL: URL?

    private var reward: Int { pattern?.xpReward ?? 50 }

    var body: some View {
        ZStack {
            PaperBackground()
            if petals && !reduceMotion {
                PetalBurst()
                    .allowsHitTesting(false)
            }
            VStack(spacing: 16) {
                Text(language.t("beautifulRangoli"))
                    .font(RangoliFont.display(30))
                    .foregroundStyle(RangoliColor.ink)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)

                artworkView
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: sizeClass == .regular ? 420 : 280)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .goldFrame(cornerRadius: 28)
                    .shadow(color: RangoliColor.gold.opacity(0.25), radius: 18, y: 8)
                    .padding(.horizontal, 28)

                HStack(spacing: 10) {
                    stat("+\(shownXP) XP")
                    stat(language.t("patternCompleted"))
                    if let pattern {
                        stat(language.format("stepsCount", pattern.stepCount))
                    }
                }
                if let pattern {
                    MetaChip(text: language.format("difficultyLabel", pattern.difficulty.localizedTitle(language.language)))
                }

                RangoliPrimaryButton(title: saved ? language.t("saved") : language.t("saveRangoli"), icon: "square.and.arrow.down") {
                    artworks.save(artwork)
                    saved = true
                    Haptics.success(settings)
                }
                .padding(.horizontal, 24)
                .courtyardControls()

                if let url = shareURL {
                    ShareLink(item: url) {
                        labelChip(language.t("share"), "square.and.arrow.up")
                    }
                    .padding(.horizontal, 24)
                    .courtyardControls()
                }

                RangoliSecondaryButton(title: language.t("createAnother"), icon: "plus") {
                    onClose()
                    router.tab = .create
                }
                .padding(.horizontal, 24)
                .courtyardControls()

                Button {
                    var copy = artwork
                    copy.isFavorite = true
                    artworks.save(copy)
                    favorited = true
                } label: {
                    Text(favorited ? language.t("inFavorites") : language.t("addToFavorites"))
                        .font(RangoliFont.headline(15))
                        .foregroundStyle(RangoliColor.primary)
                }
                .padding(.bottom, 12)
            }
            .courtyardColumn()
        }
        .preferredColorScheme(settings.colorTheme.colorScheme)
        .onAppear {
            settings.award(pattern: pattern)
            withAnimation(.easeOut(duration: 0.9)) {
                shownXP = reward
                petals = true
            }
            if let data = artwork.thumbnailPNG {
                let url = FileManager.default.temporaryDirectory.appendingPathComponent("rangoli-\(artwork.id.uuidString).png")
                try? data.write(to: url)
                shareURL = url
            }
            ReviewPrompt.recordRangoliCompleted()
            AdsManager.shared.showInterstitialAfterRangoli {
                ReviewPrompt.askIfAppropriate()
            }
        }
    }

    @ViewBuilder
    private var artworkView: some View {
        if let data = artwork.thumbnailPNG, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            RangoliPreview(motif: pattern?.motif ?? .lotusDot, progress: 1)
        }
    }

    private func stat(_ text: String) -> some View {
        Text(text)
            .font(RangoliFont.caption(12))
            .foregroundStyle(RangoliColor.maroon)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(RangoliColor.gold.opacity(0.18), in: Capsule())
    }

    private func labelChip(_ title: String, _ icon: String) -> some View {
        HStack {
            Image(systemName: icon)
            Text(title)
        }
        .font(RangoliFont.headline(16))
        .foregroundStyle(RangoliColor.primary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(RangoliColor.paper, in: Capsule())
        .overlay(Capsule().stroke(RangoliColor.primary.opacity(0.28), lineWidth: 1))
    }
}

struct PetalBurst: View {
    @State private var drift = false

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<14, id: \.self) { i in
                Text(i % 2 == 0 ? "🪷" : "❀")
                    .font(.system(size: CGFloat(12 + i % 10)))
                    .opacity(drift ? 0.15 : 0.85)
                    .offset(
                        x: drift ? CGFloat((i * 37) % 80) - 40 : CGFloat((i * 19) % 60) - 30,
                        y: drift ? geo.size.height * 0.55 : -20
                    )
                    .position(x: geo.size.width * CGFloat((i + 1) % 7 + 1) / 8, y: 40)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 2.8)) {
                drift = true
            }
        }
    }
}
