import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var language: LanguageStore
    @Environment(\.horizontalSizeClass) private var sizeClass
    private let lesson = PatternCatalog.today

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 26) {
                header
                dailyLessonCard
                collections
                popular
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
            .courtyardColumn()
        }
        .background(Color.clear)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(greeting)
                    .font(.rangoliScript(30, language: language.language))
                    .foregroundStyle(RangoliColor.ink)
                Text(language.t("homeSubtitle"))
                    .font(RangoliFont.body(16))
                    .foregroundStyle(RangoliColor.muted)
            }
            Spacer()
            VStack(spacing: 4) {
                Text("🔥")
                Text("\(max(settings.streak, 0))")
                    .font(RangoliFont.headline(14))
                    .foregroundStyle(RangoliColor.primary)
            }
            .padding(10)
            .background(RangoliColor.paper, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .goldFrame(cornerRadius: 14)
            .accessibilityLabel(language.format("streakDays", settings.streak))
        }
    }

    private var dailyLessonCard: some View {
        let pattern = lesson.pattern
        return VStack(alignment: .leading, spacing: 14) {
            NavigationLink {
                PatternDetailView(pattern: pattern)
            } label: {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(lesson.kicker(language.language))
                            .font(RangoliFont.label(11))
                            .tracking(1.2)
                            .foregroundStyle(RangoliColor.gold)
                        Spacer()
                        MetaChip(text: pattern.family.localizedTitle(language.language))
                    }
                    RangoliPreview(motif: pattern.motif, animate: true)
                        .frame(height: sizeClass == .regular ? 240 : 168)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay(GoldCornerFrame().padding(10))
                    Text(pattern.localizedTitle(language.language))
                        .font(.rangoliScript(sizeClass == .regular ? 30 : 24, language: language.language))
                        .foregroundStyle(RangoliColor.ink)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    if language.language == .tamil {
                        Text(pattern.title)
                            .font(RangoliFont.headline(16))
                            .foregroundStyle(RangoliColor.muted)
                    }
                    Text(lesson.headline(language.language))
                        .font(RangoliFont.body(15))
                        .foregroundStyle(RangoliColor.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(pattern.localizedNote(language.language))
                        .font(RangoliFont.body(14))
                        .foregroundStyle(RangoliColor.muted)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack(spacing: 8) {
                        MetaChip(text: language.format("pulliNxN", pattern.gridSize, pattern.gridSize))
                        MetaChip(text: language.format("stepsCount", pattern.stepCount))
                        if let festival = pattern.festivals.first {
                            MetaChip(text: festival.localizedTitle(language.language))
                        }
                    }
                }
            }
            .buttonStyle(PressScaleStyle(amount: 0.985))

            RangoliPrimaryButton(title: language.t("learnStepByStep"), icon: "hand.draw") {
                router.studio = StudioRoute(kind: .guided(pattern))
            }
            .courtyardControls()
            RangoliSecondaryButton(title: language.t("drawFreely"), icon: "pencil.tip") {
                router.studio = StudioRoute(kind: .dots(pattern))
            }
            .courtyardControls()
        }
        .padding(18)
        .background(
            LinearGradient(colors: [RangoliColor.paper, RangoliColor.cardWash], startPoint: .top, endPoint: .bottom),
            in: RoundedRectangle(cornerRadius: RangoliRadius.xl, style: .continuous)
        )
        .goldFrame(cornerRadius: RangoliRadius.xl)
        .shadow(color: RangoliColor.primary.opacity(0.12), radius: 18, y: 10)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(lesson.kicker(language.language)). \(pattern.localizedTitle(language.language)). \(lesson.headline(language.language))")
    }

    private var collections: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: language.t("exploreCollections"))
            if sizeClass == .regular {
                LazyVGrid(columns: CourtyardLayout.categoryColumns(regular: true), spacing: 12) {
                    collectionLinks
                }
                .environment(\.courtyardExpandedCards, true)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        collectionLinks
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    @ViewBuilder
    private var collectionLinks: some View {
        ForEach(BrowseCollection.allCases) { collection in
            NavigationLink {
                CollectionListView(collection: collection)
            } label: {
                CategoryCard(
                    title: collection.localizedTitle(language.language),
                    symbol: collection.symbol,
                    motif: PatternCatalog.matching(collection).first?.motif ?? .lotusDot
                )
            }
            .buttonStyle(PressScaleStyle())
        }
    }

    private var popular: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: language.t("kolamLessons"), subtitle: language.t("kolamLessonsSub"))
            LazyVGrid(columns: CourtyardLayout.patternColumns(regular: sizeClass == .regular), spacing: 16) {
                ForEach(PatternCatalog.popular) { pattern in
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

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return language.t("goodMorning") + " 👋"
        case 12..<17: return language.t("goodAfternoon") + " 👋"
        default: return language.t("goodEvening") + " 👋"
        }
    }
}

struct CollectionListView: View {
    let collection: BrowseCollection
    @EnvironmentObject private var language: LanguageStore
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        ScrollView {
            LazyVGrid(columns: CourtyardLayout.patternColumns(regular: sizeClass == .regular), spacing: 16) {
                ForEach(PatternCatalog.matching(collection)) { pattern in
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
        .navigationTitle(collection.localizedTitle(language.language))
        .navigationBarTitleDisplayMode(.inline)
    }
}
