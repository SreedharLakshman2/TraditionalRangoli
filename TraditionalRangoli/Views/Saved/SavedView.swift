import SwiftUI
import UIKit

struct SavedView: View {
    @EnvironmentObject private var artworks: ArtworkStore
    @EnvironmentObject private var router: AppRouter
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var segment = 0

    var body: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "My Rangolis")
                .padding(.horizontal, 20)
                .padding(.top, 8)
            Picker("Gallery", selection: $segment) {
                Text("My Creations").tag(0)
                Text("Favorites").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)

            let items = segment == 0 ? artworks.creations : artworks.favorites
            if items.isEmpty {
                Spacer()
                if segment == 0 {
                    EmptyGallery(
                        title: "Your rangoli gallery is waiting.",
                        subtitle: "Create your first traditional rangoli.",
                        button: "Create Rangoli"
                    ) {
                        router.tab = .create
                    }
                } else {
                    EmptyGallery(
                        title: "Save patterns you love.",
                        subtitle: "Favorite a courtyard piece to keep it close.",
                        button: "Explore Patterns"
                    ) {
                        router.tab = .explore
                    }
                }
                Spacer()
            } else {
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
        .courtyardColumn(1100)
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct SavedCard: View {
    let artwork: UserArtwork
    @EnvironmentObject private var artworks: ArtworkStore

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            preview
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
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
                .accessibilityLabel(artwork.isFavorite ? "Remove favorite" : "Favorite")
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
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var shareURL: URL?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                preview
                    .frame(height: sizeClass == .regular ? 420 : 320)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .goldFrame(cornerRadius: 28)
                Text(artwork.title)
                    .font(RangoliFont.display(26))
                Text(artwork.formattedDate)
                    .font(RangoliFont.caption(13))
                    .foregroundStyle(RangoliColor.muted)
                if let url = shareURL {
                    ShareLink(item: url) {
                        label("Share", "square.and.arrow.up")
                    }
                    .courtyardControls()
                }
                RangoliSecondaryButton(title: "Continue Editing", icon: "pencil.tip") {
                    router.studio = StudioRoute(kind: .continueArtwork(artwork))
                }
                .courtyardControls()
                RangoliSecondaryButton(title: "Duplicate", icon: "plus.square.on.square") {
                    artworks.duplicate(artwork)
                }
                .courtyardControls()
                Button(role: .destructive) {
                    artworks.delete(artwork)
                    dismiss()
                } label: {
                    label("Delete", "trash")
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
