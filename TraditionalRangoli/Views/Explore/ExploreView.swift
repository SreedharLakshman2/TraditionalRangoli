import SwiftUI

struct ExploreView: View {
    @EnvironmentObject private var language: LanguageStore
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var query = ""

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                SectionHeader(title: language.t("exploreTitle"), subtitle: language.t("exploreSubtitle"))
                searchField
                if query.isEmpty {
                    familySection
                    themeSection
                    festivalSection
                } else {
                    results
                }
            }
            .padding(20)
            .padding(.bottom, 12)
            .courtyardColumn()
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(RangoliColor.muted)
            TextField(language.t("searchHint"), text: $query)
                .font(RangoliFont.body(16))
                .foregroundStyle(RangoliColor.ink)
        }
        .padding(14)
        .background(RangoliColor.paper, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .goldFrame(cornerRadius: 16)
        .accessibilityLabel("Search patterns")
    }

    private var familySection: some View {
        exploreBlock(title: language.t("sectionTraditional")) {
            ForEach(PatternFamily.allCases) { family in
                let items = PatternCatalog.all.filter { $0.family == family }
                if let first = items.first {
                    NavigationLink {
                        PatternGridView(title: family.localizedTitle(language.language), patterns: items)
                    } label: {
                        CategoryCard(title: family.localizedTitle(language.language), symbol: "⚬", motif: first.motif)
                    }
                    .buttonStyle(PressScaleStyle())
                }
            }
        }
    }

    private var themeSection: some View {
        exploreBlock(title: language.t("sectionThemes")) {
            ForEach(MotifTheme.allCases) { theme in
                let items = PatternCatalog.all.filter { $0.theme == theme }
                if let first = items.first {
                    NavigationLink {
                        PatternGridView(title: theme.localizedTitle(language.language), patterns: items)
                    } label: {
                        CategoryCard(title: theme.localizedTitle(language.language), symbol: theme.symbol, motif: first.motif)
                    }
                    .buttonStyle(PressScaleStyle())
                }
            }
        }
    }

    private var festivalSection: some View {
        exploreBlock(title: language.t("sectionFestivals")) {
            ForEach(Festival.allCases) { festival in
                let items = PatternCatalog.all.filter { $0.festivals.contains(festival) }
                if let first = items.first {
                    NavigationLink {
                        PatternGridView(title: festival.localizedTitle(language.language), patterns: items)
                    } label: {
                        CategoryCard(title: festival.localizedTitle(language.language), symbol: "🪔", motif: first.motif)
                    }
                    .buttonStyle(PressScaleStyle())
                }
            }
        }
    }

    private var results: some View {
        LazyVGrid(columns: CourtyardLayout.patternColumns(regular: sizeClass == .regular), spacing: 16) {
            ForEach(PatternCatalog.search(query)) { pattern in
                NavigationLink {
                    PatternDetailView(pattern: pattern)
                } label: {
                    RangoliCard(pattern: pattern, large: true)
                }
                .buttonStyle(PressScaleStyle(amount: 0.985))
            }
        }
    }

    private func exploreBlock<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(RangoliFont.label(12))
                .tracking(1.6)
                .foregroundStyle(RangoliColor.gold)
            if sizeClass == .regular {
                LazyVGrid(columns: CourtyardLayout.categoryColumns(regular: true), spacing: 12) {
                    content()
                }
                .environment(\.courtyardExpandedCards, true)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        content()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

struct PatternGridView: View {
    let title: String
    let patterns: [RangoliPattern]
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        ScrollView {
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
            .padding(20)
            .courtyardColumn(1100)
        }
        .background(PaperBackground(showWatermark: false).ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
