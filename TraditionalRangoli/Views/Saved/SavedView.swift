import SwiftUI
import UIKit

struct SavedView: View {
    @EnvironmentObject private var artworks: ArtworkStore
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var language: LanguageStore
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var segment = 0

    var body: some View {
        VStack(spacing: 16) {
            SectionHeader(title: language.t("savedTitle"))
                .padding(.horizontal, 20)
                .padding(.top, 8)
            Picker("", selection: $segment) {
                Text(language.t("myCreations")).tag(0)
                Text(language.t("favorites")).tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)

            if segment == 0 {
                creationsBody
            } else {
                favoritesBody
            }
        }
        .courtyardColumn(1100)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var favoritePatterns: [RangoliPattern] {
        PatternCatalog.all.filter { settings.favoritePatternIds.contains($0.id) }
    }

    @ViewBuilder
    private var creationsBody: some View {
        let items = artworks.creations
        if items.isEmpty {
            Spacer()
            EmptyGallery(
                title: language.t("emptyGalleryTitle"),
                subtitle: language.t("emptyGallerySub"),
                button: language.t("createRangoli")
            ) {
                router.tab = settings.studioUnlocked ? .create : .home
            }
            Spacer()
        } else {
            artworkGrid(items)
        }
    }

    @ViewBuilder
    private var favoritesBody: some View {
        let favoriteArt = artworks.favorites
        let patterns = favoritePatterns
        if favoriteArt.isEmpty && patterns.isEmpty {
            Spacer()
            EmptyGallery(
                title: language.t("emptyFavTitle"),
                subtitle: language.t("emptyFavSub"),
                button: language.t("explorePatterns")
            ) {
                router.tab = .explore
            }
            Spacer()
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if !favoriteArt.isEmpty {
                        LazyVGrid(columns: CourtyardLayout.galleryColumns(regular: sizeClass == .regular), spacing: 12) {
                            ForEach(favoriteArt) { art in
                                NavigationLink {
                                    ArtworkDetailView(artwork: art)
                                } label: {
                                    SavedCard(artwork: art)
                                }
                                .buttonStyle(PressScaleStyle(amount: 0.98))
                            }
                        }
                    }
                    if !patterns.isEmpty {
                        LazyVGrid(columns: CourtyardLayout.patternColumns(regular: sizeClass == .regular), spacing: 16) {
                            ForEach(patterns) { pattern in
                                NavigationLink {
                                    PatternDetailView(pattern: pattern)
                                } label: {
                                    RangoliCard(pattern: pattern, large: true)
                                }
                                .buttonStyle(PressScaleStyle(amount: 0.985))
                            }
                        }
                    }
                }
                .padding(20)
                .padding(.bottom, 12)
                .courtyardColumn(1100)
            }
        }
    }

    private func artworkGrid(_ items: [UserArtwork]) -> some View {
        ScrollView {
            LazyVGrid(columns: CourtyardLayout.galleryColumns(regular: sizeClass == .regular), spacing: 12) {
                ForEach(items) { art in
                    NavigationLink {
                        ArtworkDetailView(artwork: art)
                    } label: {
                        SavedCard(artwork: art)
                    }
                    .buttonStyle(PressScaleStyle(amount: 0.98))
                }
            }
            .padding(20)
            .padding(.bottom, 12)
            .courtyardColumn(1100)
        }
    }
}

struct SavedCard: View {
    let artwork: UserArtwork
    @EnvironmentObject private var artworks: ArtworkStore
    @EnvironmentObject private var language: LanguageStore

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay { preview }
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .clipped()
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(artwork.title)
                        .font(RangoliFont.headline(13))
                        .foregroundStyle(RangoliColor.ink)
                        .lineLimit(1)
                    Text(artwork.formattedDate)
                        .font(RangoliFont.caption(11))
                        .foregroundStyle(RangoliColor.muted)
                }
                Spacer()
                Button {
                    artworks.toggleFavorite(artwork)
                } label: {
                    Image(systemName: artwork.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(RangoliColor.primary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(artwork.isFavorite ? language.t("favorited") : language.t("favorite"))
            }
        }
        .padding(10)
        .paperCard(radius: RangoliRadius.md)
    }

    @ViewBuilder
    private var preview: some View {
        if let data = artwork.thumbnailPNG, let image = UIImage(data: data) {
            Image(uiImage: image).resizable().scaledToFill()
        } else {
            RangoliPreview(motif: artwork.patternId.flatMap(PatternCatalog.pattern(id:))?.motif ?? .lotusDot)
        }
    }
}

struct ArtworkDetailView: View {
    let artwork: UserArtwork
    @EnvironmentObject private var artworks: ArtworkStore
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var language: LanguageStore
    @Environment(\.dismiss) private var dismiss
    @State private var shareURL: URL?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                preview
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .goldFrame(cornerRadius: 28)
                Text(artwork.title)
                    .font(RangoliFont.display(26))
                Text(artwork.formattedDate)
                    .font(RangoliFont.caption(13))
                    .foregroundStyle(RangoliColor.muted)
                if let url = shareURL {
                    ShareLink(item: url) {
                        label(language.t("share"), "square.and.arrow.up")
                    }
                    .courtyardControls()
                }
                RangoliSecondaryButton(title: language.t("continueEditing"), icon: "pencil.tip") {
                    router.studio = StudioRoute(kind: .continueArtwork(artwork))
                }
                .courtyardControls()
                RangoliSecondaryButton(title: language.t("duplicate"), icon: "plus.square.on.square") {
                    artworks.duplicate(artwork)
                }
                .courtyardControls()
                Button(role: .destructive) {
                    artworks.delete(artwork)
                    dismiss()
                } label: {
                    label(language.t("delete"), "trash")
                }
                .courtyardControls()
            }
            .padding(20)
            .courtyardColumn()
        }
        .background(PaperBackground(showWatermark: false).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let data = artwork.thumbnailPNG {
                let url = FileManager.default.temporaryDirectory.appendingPathComponent("rangoli-\(artwork.id.uuidString).png")
                try? data.write(to: url)
                shareURL = url
            }
        }
    }

    @ViewBuilder
    private var preview: some View {
        if let data = artwork.thumbnailPNG, let image = UIImage(data: data) {
            Image(uiImage: image).resizable().scaledToFit()
        } else {
            RangoliPreview(motif: artwork.patternId.flatMap(PatternCatalog.pattern(id:))?.motif ?? .lotusDot)
        }
    }

    private func label(_ title: String, _ icon: String) -> some View {
        HStack {
            Image(systemName: icon)
            Text(title)
        }
        .font(RangoliFont.headline(16))
        .foregroundStyle(RangoliColor.primary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(RangoliColor.paper, in: Capsule())
    }
}
